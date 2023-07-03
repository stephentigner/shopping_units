import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/utils/application_strings.dart';

class ComparisonItem extends StatelessWidget {
  final ItemDetails details;

  ComparisonItem({Key? key, required this.details}) : super(key: key);

  //TextEditingControllers
  final _itemNameController = TextEditingController();
  final _packagePriceController = TextEditingController();
  final _packageUnitsAmountController = TextEditingController();
  final _numberOfItemsController = TextEditingController();
  final _amountPerItemController = TextEditingController();

  final _currencyFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d{0,2}"));
  final _unitsFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"));

  void _initControllers() {
    _itemNameController.text = details.name;
    _packagePriceController.text = details.packagePrice.toString();
    _packageUnitsAmountController.text = details.packageUnitsAmount.toString();
    _numberOfItemsController.text = details.itemCount.toString();
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
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _itemNameController,
                decoration: const InputDecoration(
                  hintText: ApplicationStrings.itemNameHintText,
                ),
              ),
            ),
          ],
        ),
        Row(children: [
          Expanded(
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: true),
              controller: _packagePriceController,
              decoration: const InputDecoration(
                hintText: ApplicationStrings.packagePriceHintText,
              ),
              inputFormatters: [_currencyFormatter],
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: true),
              controller: _packageUnitsAmountController,
              decoration: const InputDecoration(
                hintText: ApplicationStrings.packageUnitsAmountHintText,
              ),
              inputFormatters: [_unitsFormatter],
            ),
          ),
        ]),
        if (details.packageUnits == UnitType.each)
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  controller: _numberOfItemsController,
                  decoration: const InputDecoration(
                    hintText: ApplicationStrings.numberOfItemsHintText,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  controller: _amountPerItemController,
                  decoration: const InputDecoration(
                    hintText: ApplicationStrings.amountPerItemHintText,
                  ),
                ),
              ),
            ],
          ),
        if (details.standardizedPrice > 0)
          Row(
            children: [
              Expanded(
                child: Text(
                    "${details.standardizedPrice.toStringAsFixed(2)}/${details.standardizedUnits.abbreviation}"),
              ),
            ],
          ),
      ],
    );
  }
}
