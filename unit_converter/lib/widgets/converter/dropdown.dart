import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:unit_converter/model/unit.dart';

class Dropdown extends StatefulWidget {
  final List<Unit> units;
  final ValueChanged<double> onChangeHandler;

  const Dropdown({
    Key key,
    @required this.units,
    @required this.onChangeHandler
  }) : assert(units != null),
       assert(onChangeHandler != null),
       super(key: key);

  @override
  State<StatefulWidget> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<DropdownMenuItem> _dropdownMenuItems;
  String _selectedValue;

  void _createDropdownMenuItems() {
    final List<DropdownMenuItem> items = <DropdownMenuItem>[];

    for (Unit unit in widget.units) {
      items.add(
          DropdownMenuItem(
              value: unit.conversion.toString(),
              child: Container(
                child: Text(
                  unit.name,
                  softWrap: true,
                ),
              )
          )
      );
    }

    this._dropdownMenuItems = items;
  }

  void _setDefaultState() {
    setState(() {
      this._selectedValue = widget.units[0].conversion.toString();
    });
  }

  void _handleOnChange(dynamic value) {
    setState(() {
      this._selectedValue = value;
    });

    try {
      final double valueAsDouble = double.parse(value);
      widget.onChangeHandler(valueAsDouble);
    } on Exception {
      print('Cannot convert conversion value "$value" to double, '
          'unit misconfigured?');
    }
  }

  @override
  void initState() {
    super.initState();

    this._createDropdownMenuItems();
    this._setDefaultState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          // This sets the color of the [DropdownButton] itself
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[400],
            width: 1.0,
          ),
        ),
        // A top and bottom padding
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Theme(
          // This sets the color of the [DropdownMenuItem]s
            data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[50],
            ),
            child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    value: this._selectedValue,
                    items: this._dropdownMenuItems,
                    onChanged: this._handleOnChange,
                    style: Theme.of(context).textTheme.title,
                  ),
                )
            )
        )
    );
  }
}