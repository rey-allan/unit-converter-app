// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/widgets/converter/dropdown.dart';
import 'package:unit_converter/widgets/converter/numeric_input.dart';
import 'package:unit_converter/widgets/converter/numeric_output.dart';

/// Converter screen where users can input amounts to convert.
class ConverterScreen extends StatefulWidget {
  final String name;
  final ColorSwatch color;
  final List<Unit> units;

  /// This [ConverterScreen] requires the name, color, and units to not be null.
  const ConverterScreen({
    @required this.name,
    @required this.color,
    @required this.units,
  }) : assert(name != null),
       assert(color != null),
       assert(units != null);

  @override
  State<StatefulWidget> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double _inputValue;
  double _outputValue;
  double _toConversion;
  double _fromConversion;

  void _updateConversion() {
    setState(() {
      this._outputValue =
          this._inputValue * (this._toConversion / this._fromConversion);
    });
  }

  void _handleOnInputValueChange(double inputValue) {
    setState(() {
      this._inputValue = inputValue;
      this._updateConversion();
    });
  }

  void _handleOnFromConversionValueChange(double fromConversion) {
    setState(() {
      this._fromConversion = fromConversion;
      this._updateConversion();
    });
  }

  void _handleOnToConversionValueChange(double toConversion) {
    setState(() {
      this._toConversion = toConversion;
      this._updateConversion();
    });
  }

  Widget _buildVerticallyCenteredGroup(List<Widget> components) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: components,
      )
    );
  }

  Widget _buildInputGroup() {
    return this._buildVerticallyCenteredGroup(
        <Widget>[
          NumericInput(
            label: 'Input',
            onChangeHandler: (value) => this._handleOnInputValueChange(value),
          ),
          // Add some padding to create space between components
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Dropdown(
            units: widget.units,
            onChangeHandler: (value) =>
                this._handleOnFromConversionValueChange(value),
          ),
        ]
    );
  }

  Widget _buildOutputGroup() {
    return this._buildVerticallyCenteredGroup(
        <Widget>[
          NumericOutput(
            label: 'Output',
            value: this._outputValue,
          ),
          // Add some padding to create space between components
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Dropdown(
            units: widget.units,
            onChangeHandler: (value) =>
                this._handleOnToConversionValueChange(value),
          ),
        ]
    );
  }

  @override
  void initState() {
    super.initState();

    this._fromConversion = widget.units[0].conversion;
    this._toConversion = widget.units[0].conversion;
  }

  @override
  Widget build(BuildContext context) {
    final Widget inputGroup = this._buildInputGroup();
    final Widget outputGroup = this._buildOutputGroup();
    final Widget conversionArrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final Widget converterGroup = Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          inputGroup,
          conversionArrows,
          outputGroup,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: Theme.of(context).textTheme.display1,
        ),
        backgroundColor: widget.color,
        centerTitle: true,
      ),
      body: converterGroup,
      // This prevents resizing the screen when the keyboard is opened
      resizeToAvoidBottomPadding: false,
    );
  }
}