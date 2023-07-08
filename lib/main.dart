import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shopping_units/enums/comparison_item_field.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/widgets/comparison_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MyHomePage(title: 'Price Comparison'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LinkedHashMap<UniqueKey, ItemDetails> _comparisonItems =
      LinkedHashMap<UniqueKey, ItemDetails>();
  final _isFluidMeasure = false;

  void _addComparisonItem() {
    ItemDetails newItem = ItemDetails();
    _comparisonItems[newItem.key] = newItem;
  }

  void _addComparisonItemToState() {
    setState(() {
      _addComparisonItem();
    });
  }

  void _changeUnitDropdown(
    ItemDetails item,
    ComparisonItemField dropdown,
    UnitType? newValue,
  ) {
    UnitType nullSafeNewValue =
        newValue ?? UnitType.defaultUnit(_isFluidMeasure);
    setState(() {
      switch (dropdown) {
        case ComparisonItemField.packageUnits:
          item.packageUnits = nullSafeNewValue;
          break;
        default:
        //if unmatched, do nothing for now
      }
    });
  }

  void _changeTextField(
    ItemDetails item,
    ComparisonItemField field,
    String newValue,
  ) {
    //pre-process values when applicable to reduce duplicate code
    double? parsedDouble;
    bool validDouble = false;

    switch (field) {
      case ComparisonItemField.packagePrice:
      case ComparisonItemField.packageUnitsAmount:
        parsedDouble = double.tryParse(newValue);
        validDouble = parsedDouble != null && parsedDouble >= 0;
        break;
      default:
      //if unmatched, do nothing for now
    }

    setState(() {
      switch (field) {
        case ComparisonItemField.name:
          item.name = newValue;
          break;
        case ComparisonItemField.packagePrice:
          //Only update the model if the parsedPrice is a valid price
          //A valid price is parseable and is greater than or equal to 0
          if (validDouble) {
            item.packagePrice = parsedDouble!;
          }
          break;
        case ComparisonItemField.packageUnitsAmount:
          if (validDouble) {
            item.packageUnitsAmount = parsedDouble!;
          }
          break;
        default:
        //if unmatched, do nothing for now
      }
    });
  }

  @override
  void initState() {
    _addComparisonItem();
    _addComparisonItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          shrinkWrap: false,
          children: _comparisonItems.values
              .map((e) => ComparisonItem(
                    details: e,
                    onChangedUnitDropdown: _changeUnitDropdown,
                    onBlurTextField: _changeTextField,
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addComparisonItemToState,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
