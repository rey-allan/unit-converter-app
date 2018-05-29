// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:unit_converter/widgets/category.dart';

/// Category Screen
///
/// This is the 'home' screen of the Unit Converter.
/// It shows a header and a list of [Category].
class CategoryScreen extends StatelessWidget {
  const CategoryScreen();

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

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    // Build a list of `Category` widgets to use in a `ListView`
    final List<Widget> categories = <Widget>[];

    for (int i = 0; i < _categoryNames.length; i++) {
      categories.add(
          Category(
            icon: Icons.cake,
            color: _baseColors[i],
            text: _categoryNames[i],
            onTapHandler: () => print('I was tapped!'),
          )
      );
    }

    final listView = ListView(
      children: categories,
      padding: EdgeInsets.all(8.0),
    );

    final appBar = AppBar(
      title: Center(
        child: Text(
          'Unit Converter',
          style: TextStyle(fontSize: 30.0, color: Colors.black),
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.green[100],
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
      backgroundColor: Colors.green[100],
    );
  }
}