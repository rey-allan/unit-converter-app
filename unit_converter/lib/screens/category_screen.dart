// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:unit_converter/widgets/category.dart';

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

  // Build a list of `Category` widgets to use in a `ListView`
  final List<Widget> _categories = <Widget>[];

  @override
  void initState() {
    // Create the list of categories at initialization
    for (int i = 0; i < _categoryNames.length; i++) {
      _categories.add(
          Category(
            icon: Icons.cake,
            color: _baseColors[i],
            text: _categoryNames[i],
          )
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView(
      children: _categories,
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