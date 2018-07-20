// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:unit_converter/model/category.dart';
import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/screens/converter_screen.dart';
import 'package:unit_converter/widgets/backdrop.dart';
import 'package:unit_converter/widgets/category_tile.dart';

/// Category Screen
///
/// This is the 'home' screen of the Unit Converter.
/// It shows a header and a list of [Category].
class CategoryScreen extends StatefulWidget {
  const CategoryScreen();

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

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

  /// Generates a list of mock [Unit]s.
  List<Unit> _generateUnits(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  /// Function to call when a [Category] is tapped
  void _onCategoryTap(Category category) {
    setState(() {
      this._currentCategory = category;
    });
  }

  @override
  void initState() {
    super.initState();

    // Create the list of categories at initialization
    for (int i = 0; i < _categoryNames.length; i++) {
      _categories.add(
          CategoryTile(
            category: Category(
              name: _categoryNames[i],
              color: _baseColors[i],
              units: this._generateUnits(_categoryNames[i]),
              iconLocation: Icons.cake,
            ),
            onTapHandler: this._onCategoryTap,
          )
      );
    }

    // Set the default [Category] for the unit converter that opens
    this._currentCategory = this._categories[0].category;
  }

  @override
  Widget build(BuildContext context) {
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
      frontPanel: ConverterScreen(category: this._currentCategory),
      backPanel: categoriesView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }
}
