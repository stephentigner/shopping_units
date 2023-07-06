import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_units/enums/comparison_item_field.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/utils/application_strings.dart';

class ComparisonItem extends StatelessWidget {
  final ItemDetails details;
  final void Function(ItemDetails, ComparisonItemField, UnitType?)
      onChangedUnitDropdown;
  final void Function(ItemDetails, ComparisonItemField, String)
      onChangedTextField;

  ComparisonItem(
      {Key? key,
      required this.details,
      required this.onChangedUnitDropdown,
      required this.onChangedTextField})
      : super(key: key);

  //TextEditingControllers
  final _itemNameController = TextEditingController();
  final _packagePriceController = TextEditingController();
  final _packageUnitsAmountController = TextEditingController();
  final _itemCountController = TextEditingController();
  final _amountPerItemController = TextEditingController();

  //At the time of this writing (2023-07-03), the FilteringTextInputFormatter
  //documentation mentions that it "typically shouldn't be used with RegExps
  //that contain positional matchers (^ or $) since these patterns are usually
  //meant for matching the whole string". In this case, we are indeed trying to
  //match against the whole string because we need to insure constraints such as
  //only one decimal point and only two decimal digits for currency
  final _currencyFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"));
  final _unitsFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"));
  final _integerFormatter = FilteringTextInputFormatter.digitsOnly;

  void _initControllers() {
    _itemNameController.text = details.name;
    _packagePriceController.text = details.packagePrice.toString();
    _packageUnitsAmountController.text = details.packageUnitsAmount.toString();
    _itemCountController.text = details.itemCount.toString();
    _amountPerItemController.text = details.itemUnitsAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    _initControllers();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    hintText: ApplicationStrings.itemNameHintText,
                  ),
                  onChanged: (value) => onChangedTextField(
                      details, ComparisonItemField.name, value),
                ),
              ),
            ),
          ],
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                controller: _packagePriceController,
                decoration: const InputDecoration(
                  hintText: ApplicationStrings.packagePriceHintText,
                ),
                inputFormatters: [_currencyFormatter],
                onChanged: (value) => onChangedTextField(
                    details, ComparisonItemField.packagePrice, value),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                controller: _packageUnitsAmountController,
                decoration: const InputDecoration(
                  hintText: ApplicationStrings.packageUnitsAmountHintText,
                ),
                inputFormatters: [_unitsFormatter],
                onChanged: (value) => onChangedTextField(
                    details, ComparisonItemField.packageUnitsAmount, value),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<UnitType>(
                  value: details.packageUnits,
                  items: UnitType.values
                      .map((e) => DropdownMenuItem<UnitType>(
                            value: e,
                            child: Text(e.abbreviation),
                          ))
                      .toList(),
                  onChanged: (value) => {
                    onChangedUnitDropdown(
                        details, ComparisonItemField.packageUnits, value)
                  },
                ),
              ),
            ),
          ),
        ]),
        if (details.packageUnits == UnitType.each)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    controller: _itemCountController,
                    decoration: const InputDecoration(
                      hintText: ApplicationStrings.itemCountHintText,
                    ),
                    inputFormatters: [_integerFormatter],
                    onChanged: (value) => onChangedTextField(
                        details, ComparisonItemField.itemCount, value),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    controller: _amountPerItemController,
                    decoration: const InputDecoration(
                      hintText: ApplicationStrings.amountPerItemHintText,
                    ),
                    inputFormatters: [_unitsFormatter],
                    onChanged: (value) => onChangedTextField(
                        details, ComparisonItemField.itemUnitsAmount, value),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<UnitType>(
                      value: details.itemUnits,
                      items: UnitType.values
                          .map((e) => DropdownMenuItem<UnitType>(
                                value: e,
                                child: Text(e.abbreviation),
                              ))
                          .toList(),
                      onChanged: (value) => {
                        onChangedUnitDropdown(
                            details, ComparisonItemField.itemUnits, value)
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (details.standardizedPrice > 0)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${details.standardizedPrice.toStringAsFixed(2)}/${details.standardizedUnits.abbreviation}"),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
