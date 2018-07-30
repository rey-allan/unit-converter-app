// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:unit_converter/model/category.dart';

/// A custom [CategoryTile] widget to display a [Category] instance,
///
/// The widget is composed of an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class CategoryTile extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onTapHandler;

  /// Creates a [CategoryTile].
  ///
  /// A [CategoryTile] saves the name of the [Category] (e.g. 'Length'), its
  /// color for the UI, and the icon that represents it (e.g. a ruler).
  const CategoryTile({
    @required this.category,
    @required this.onTapHandler
  }) : assert(category != null),
       assert(onTapHandler != null);

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
        highlightColor: this.category.color['highlight'],
        splashColor: this.category.color['splash'],
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        onTap: () => this.onTapHandler(this.category),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset(
                    this.category.iconLocation,
                  ),
                ),
                Text(
                  this.category.name,
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