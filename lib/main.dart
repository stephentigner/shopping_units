import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shopping_units/enums/comparison_item_field.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/utils/application_strings.dart';
import 'package:shopping_units/widgets/comparison_item.dart';
import 'package:shopping_units/widgets/comparison_list.dart';
import 'package:toggle_switch/toggle_switch.dart';

void main() {
  runApp(const ShoppingUnits());
}

class ShoppingUnits extends StatelessWidget {
  const ShoppingUnits({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price comparison',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(title: 'Price Comparison'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const int _deletionNoticeTimeoutInSeconds = 30;
  final ComparisonList _comparisonList = const ComparisonList();

  bool _isFluidMeasure = false;
  int _measureTypeIndex = 0;
  UnitType _standardizedUnits = UnitType.defaultSolidUnit;

  void _toggleMeasureType(int? measureTypeIndex) {
    setState(() {
      _measureTypeIndex = measureTypeIndex ?? 0;
      switch (measureTypeIndex) {
        case 0:
          _isFluidMeasure = false;
          break;
        case 1:
          _isFluidMeasure = true;
          break;
        default:
        //if unmatched, do nothing for now
      }

      // for (var item in _comparisonItems.values) {
      //   item.isFluidMeasure = _isFluidMeasure;
      // }
      _standardizedUnits = UnitType.defaultUnit(_isFluidMeasure);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _comparisonList,
      ),
      persistentFooterButtons: [
        Row(
          children: [
            ToggleSwitch(
              totalSwitches: 2,
              labels: const ['Solid', 'Liquid'],
              initialLabelIndex: _measureTypeIndex,
              onToggle: _toggleMeasureType,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(ApplicationStrings.standardizedUnitsLabel),
            ),
            DropdownButton<UnitType>(
              value: _standardizedUnits,
              items: UnitType.filteredValues(_isFluidMeasure)
                  .map((e) => DropdownMenuItem<UnitType>(
                        value: e,
                        child: Text(e.pluralAbbreviation),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  UnitType nullCheckedValue =
                      value ?? UnitType.defaultUnit(_isFluidMeasure);
                  _standardizedUnits = nullCheckedValue;
                  // for (var element in _comparisonItems.values) {
                  //   element.standardizedUnits = nullCheckedValue;
                  // }
                });
              },
            )
          ],
        )
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, //_addComparisonItemToState,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
