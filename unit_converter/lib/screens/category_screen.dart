// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unit_converter/model/category.dart';
import 'package:unit_converter/model/currency_provider.dart';
import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/screens/converter_screen.dart';
import 'package:unit_converter/widgets/backdrop.dart';
import 'package:unit_converter/widgets/category_tile.dart';

/// Category Screen
///
/// Loads in unit conversion data, and displays the data.
/// This is the main screen to our app. It retrieves conversion data from a
/// JSON asset and from an API. It displays the [Categories] in the back panel
/// of a [Backdrop] widget and shows the [UnitConverter] in the front panel.
class CategoryScreen extends StatefulWidget {
  final CurrencyProvider currencyProvider;

  const CategoryScreen({this.currencyProvider});

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const _icons = {
    'Length': 'assets/icons/length.png',
    'Area': 'assets/icons/area.png',
    'Volume': 'assets/icons/volume.png',
    'Mass': 'assets/icons/mass.png',
    'Time': 'assets/icons/time.png',
    'Digital Storage': 'assets/icons/digital_storage.png',
    'Energy': 'assets/icons/power.png',
    'Currency': 'assets/icons/currency.png',
  };

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  final List<CategoryTile> _categories = <CategoryTile>[];

  // Keep track of a currently selected [Category]
  Category _currentCategory;
  bool _isLoading = true;

  /// Retrieves a list of [Categories] and their [Unit]s from a local file
  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables
    // See: https://www.dartlang.org/guides/language/effective-dart/usage
    final json =
        DefaultAssetBundle.of(context).loadString('assets/data/units.json');

    final data = JsonDecoder().convert(await json);

    if (data is! Map) {
      throw ('Data retrieved from assets is not a Map');
    }

    int categoryIndex = 0;

    // Create a [Category] with its list of [Unit]s from the JSON asset
    data.keys.forEach((key) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic unit) => Unit.fromJson(unit)).toList();

      // The state needs to be updated to make sure orientation changes work
      // as well as the unit converter selection via the [Backdrop]
      setState(() {
        this._categories.add(CategoryTile(
              category: Category(
                name: key,
                color: _baseColors[categoryIndex],
                units: units,
                iconLocation: _icons[key],
              ),
              onTapHandler: this._onCategoryTap,
            ));
      });

      categoryIndex++;
    });

    setState(() {
      this._currentCategory = this._categories[0].category;
    });
  }

  /// Retrieves the units for the Currency [Category] from an external provider
  Future<void> _retrieveCurrencyCategory() async {
    bool shouldBeDisabled = false;
    List<Unit> units = [];

    try {
      units = await widget.currencyProvider.getUnits();
    } catch (e) {
      print('Caught an exception while retrieving Currency units: $e');
      shouldBeDisabled = true;
    }

    setState(() {
      this._categories.add(
          CategoryTile(
            category: Category(
              name: 'Currency',
              color: _baseColors.last,
              units: units,
              iconLocation: _icons['Currency'],
            ),
            onTapHandler: this._onCategoryTap,
            disabled: shouldBeDisabled,
          )
      );
    });
  }

  /// Makes the correct number of rows for the categories, based on whether the
  /// device is portrait or landscape. For portrait, use a [ListView], and for
  /// landscape, a [GridView].
  Widget _buildCategoryWidgets(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return ListView(
        children: this._categories,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: this._categories,
      );
    }
  }

  /// Function to call when a [Category] is tapped
  void _onCategoryTap(Category category) {
    setState(() {
      this._currentCategory = category;
    });
  }

  // We use `didChangeDependencies()` so that we can wait for our JSON asset
  // to be loaded in (async)
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our assets file and we want to
    // also obtain uo-to-date currency conversions from an external provider
    if (this._categories.isEmpty) {
      await this._retrieveLocalCategories();
      await this._retrieveCurrencyCategory();

      setState(() {
        this._isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Since we are now loading our assets async, we need to make sure the
    // list of categories is not built until all assets have been loaded
    // so we can add a progress indicator while the async job finishes
    if (this._isLoading) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    final categoriesView = Padding(
      child: this._buildCategoryWidgets(MediaQuery.of(context).orientation),
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        // The bottom padding for the back panel should be 48.0, to give it
        // space for the bottom tab of the front panel of the [Backdrop]
        bottom: 48.0,
      ),
    );

    return Backdrop(
      currentCategory: this._currentCategory,
      frontPanel: ConverterScreen(
        category: this._currentCategory,
        currencyProvider: widget.currencyProvider,
      ),
      backPanel: categoriesView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }
}
