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
  final void Function(ItemDetails, ComparisonItemField, String) onBlurTextField;
  final void Function(ItemDetails) onDeleteItem;
  final void Function(ItemDetails) onRestoreItem;

  ComparisonItem(
      {Key? key,
      required this.details,
      required this.onChangedUnitDropdown,
      required this.onBlurTextField,
      required this.onDeleteItem,
      required this.onRestoreItem})
      : super(key: key);

  //TextEditingControllers
  final _itemNameController = TextEditingController();
  final _packagePriceController = TextEditingController();
  final _packageUnitsAmountController = TextEditingController();

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

  void _initControllers() {
    _itemNameController.text = details.name;
    _packagePriceController.text = details.packagePrice != null
        ? details.packagePrice!.toStringAsFixed(2)
        : "";
    _packageUnitsAmountController.text = details.packageUnitsAmount != null
        ? details.packageUnitsAmount.toString()
        : "";
  }

  @override
  Widget build(BuildContext context) {
    _initControllers();

    if (details.isDeleted) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    details.deletedItemLabel,
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => onRestoreItem(details),
                  child: Text(
                    "${ApplicationStrings.restoreItemLabel} (${details.deletionNoticeTimeRemaining})",
                    textScaleFactor: 1.5,
                  ))
            ],
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Focus(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _itemNameController,
                      decoration: const InputDecoration(
                        labelText: ApplicationStrings.itemNameLabel,
                      ),
                    ),
                    onFocusChange: (hasFocus) => onBlurTextField(details,
                        ComparisonItemField.name, _itemNameController.text),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => onDeleteItem(details),
                  icon: const Icon(Icons.delete))
            ],
          ),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Focus(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    controller: _packagePriceController,
                    decoration: const InputDecoration(
                      labelText: ApplicationStrings.packagePriceLabel,
                      prefixIcon: Text(
                        "\$",
                        textScaleFactor: 2,
                      ),
                    ),
                    inputFormatters: [_currencyFormatter],
                  ),
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      onBlurTextField(details, ComparisonItemField.packagePrice,
                          _packagePriceController.text);
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Focus(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    controller: _packageUnitsAmountController,
                    decoration: const InputDecoration(
                      labelText: ApplicationStrings.packageUnitsAmountLabel,
                    ),
                    inputFormatters: [_unitsFormatter],
                  ),
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      onBlurTextField(
                          details,
                          ComparisonItemField.packageUnitsAmount,
                          _packageUnitsAmountController.text);
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UnitType>(
                    value: details.packageUnits,
                    items: UnitType.filteredValues(details.isFluidMeasure)
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
          if (details.standardizedPrice > 0)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(details.standardizedPriceDisplay),
                  ),
                ),
              ],
            ),
        ],
      );
    }
  }
}
