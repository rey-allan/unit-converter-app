// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/screens/converter_screen.dart';

/// A custom [Category] widget.
///
/// The widget is composed of an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class Category extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final GestureTapCallback onTapHandler;

  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  const Category({
    @required this.icon,
    @required this.color,
    @required this.text,
    this.onTapHandler
  }) : assert(icon != null),
       assert(color != null),
       assert(text != null);

  /// Navigates to the [ConverterScreen] acting as a default `onTap` handler.
  void _navigateToConverter(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) {
        return new ConverterScreen(
            name: this.text,
            color: this.color,
            units: this._generateUnits(),
        );
      }),
    );
  }

  /// Generates a list of mock [Unit]s.
  List<Unit> _generateUnits() {
    return List.generate(10, (int i ) {
      i += 1;
      return Unit(
        name: '${this.text} Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  /// Builds a custom widget that shows [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: InkWell(
        highlightColor: this.color,
        splashColor: this.color,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        onTap: null != this.onTapHandler ? this.onTapHandler :
               () => this._navigateToConverter(context),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    this.icon,
                    size: 60.0,
                  ),
                ),
                Text(
                  this.text,
                  style: TextStyle(fontSize: 24.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}