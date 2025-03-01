/*
Copyright (C) 2023 Stephen Tigner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_units/enums/comparison_item_field.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/utils/application_strings.dart';

class ComparisonItem extends StatefulWidget {
  final ItemDetails details = ItemDetails();
  final int deletionNoticeTimeoutInSeconds;
  final void Function(ItemDetails)? onItemMarkedDeleted;
  final void Function(ItemDetails)? onDeleteItem;

  ComparisonItem({
    Key? key,
    required this.deletionNoticeTimeoutInSeconds,
    this.onItemMarkedDeleted,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  State<ComparisonItem> createState() => _ComparisonItemState();
}

class _ComparisonItemState extends State<ComparisonItem> {
  ItemDetails get _details => widget.details;

  //TextEditingControllers
  final _itemNameController = TextEditingController();
  final _packagePriceController = TextEditingController();
  final _packageUnitsAmountController = TextEditingController();
  final _packageItemCountController = TextEditingController();

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
  final _integerFormatter = FilteringTextInputFormatter.allow(RegExp(r"^\d+"));

  void _initControllers() {
    _itemNameController.text = _details.name;
    _packagePriceController.text = _details.packagePrice != null
        ? _details.packagePrice!.toStringAsFixed(2)
        : "";
    _packageUnitsAmountController.text = _details.packageUnitsAmount != null
        ? _details.packageUnitsAmount.toString()
        : "";
    _packageItemCountController.text = _details.packageItemCount.toString();
  }

  @override
  void initState() {
    _initControllers();
    super.initState();
  }

  void _changeUnitDropdown(
    ComparisonItemField dropdown,
    UnitType? newValue,
  ) {
    UnitType nullSafeNewValue =
        newValue ?? UnitType.defaultUnit(_details.isFluidMeasure);
    setState(() {
      switch (dropdown) {
        case ComparisonItemField.packageUnits:
          _details.packageUnits = nullSafeNewValue;
          break;
        default:
        //if unmatched, do nothing for now
      }
    });
  }

  void _changeTextField(
    ComparisonItemField field,
    String newValue,
  ) {
    //pre-process values when applicable to reduce duplicate code
    double? parsedDouble;
    bool validDouble = false;
    int? parsedInt;
    bool validInt = false;

    switch (field) {
      case ComparisonItemField.packagePrice:
      case ComparisonItemField.packageUnitsAmount:
        parsedDouble = double.tryParse(newValue);
        validDouble = parsedDouble != null && parsedDouble >= 0;
        break;
      case ComparisonItemField.packageItemCount:
        parsedInt = int.tryParse(newValue);
        validInt = parsedInt != null && parsedInt >= 1;
        break;
      default:
      //if unmatched, do nothing for now
    }

    setState(() {
      switch (field) {
        case ComparisonItemField.name:
          _details.name = newValue;
          break;
        case ComparisonItemField.packagePrice:
          //Only update the model if the parsedPrice is a valid price
          //A valid price is parseable and is greater than or equal to 0
          if (validDouble) {
            _details.packagePrice = parsedDouble!;
          }
          break;
        case ComparisonItemField.packageUnitsAmount:
          if (validDouble) {
            _details.packageUnitsAmount = parsedDouble!;
          }
          break;
        case ComparisonItemField.packageItemCount:
          if (validInt) {
            _details.packageItemCount = parsedInt!;
          }
          break;
        default:
        //if unmatched, do nothing for now
      }
    });
  }

  void _deleteItem() {
    setState(() {
      _details.isDeleted = true;
      _details.deletionNoticeTimeRemaining =
          widget.deletionNoticeTimeoutInSeconds;
    });
    //If there is an existing timer for this item, cancel it
    _details.deletionNoticeTimer?.cancel();
    _details.deletionNoticeTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _details.deletionNoticeTimeRemaining--;
        if (_details.deletionNoticeTimeRemaining <= 0) {
          timer.cancel();
          if (_details.isDeleted && widget.onDeleteItem != null) {
            widget.onDeleteItem!(_details);
          }
        }
      });
    });
    if (widget.onItemMarkedDeleted != null) {
      widget.onItemMarkedDeleted!(_details);
    }
  }

  void _restoreItem() {
    setState(() {
      _details.isDeleted = false;
      _details.deletionNoticeTimer?.cancel();
      _details.deletionNoticeTimeRemaining = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_details.isDeleted) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _details.deletedItemLabel,
                    textScaler: const TextScaler.linear(1.5),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => _restoreItem(),
                  child: Text(
                    "${ApplicationStrings.restoreItemLabel} (${_details.deletionNoticeTimeRemaining})",
                    textScaler: const TextScaler.linear(1.5),
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
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _itemNameController,
                    decoration: const InputDecoration(
                      labelText: ApplicationStrings.itemNameLabel,
                    ),
                    onChanged: (value) =>
                        _changeTextField(ComparisonItemField.name, value),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => _deleteItem(),
                  icon: const Icon(Icons.delete))
            ],
          ),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  controller: _packagePriceController,
                  decoration: const InputDecoration(
                    labelText: ApplicationStrings.packagePriceLabel,
                    prefixIcon: Text(
                      ApplicationStrings.currencySymbol,
                      textScaler: TextScaler.linear(2),
                    ),
                  ),
                  inputFormatters: [_currencyFormatter],
                  onChanged: (value) =>
                      _changeTextField(ComparisonItemField.packagePrice, value),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: _details.isMultiPack,
                    onChanged: (bool? value) {
                      setState(() {
                        _details.isMultiPack = value ?? false;
                      });
                    },
                  ),
                  const Text(ApplicationStrings.multiPackLabel),
                ],
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  controller: _packageUnitsAmountController,
                  decoration: const InputDecoration(
                    labelText: ApplicationStrings.packageUnitsAmountLabel,
                  ),
                  inputFormatters: [_unitsFormatter],
                  onChanged: (value) => _changeTextField(
                      ComparisonItemField.packageUnitsAmount, value),
                ),
              ),
            ),
            if (_details.isMultiPack)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _packageItemCountController,
                    decoration: const InputDecoration(
                      labelText: ApplicationStrings.packageItemCountLabel,
                    ),
                    inputFormatters: [_integerFormatter],
                    onChanged: (value) => _changeTextField(
                        ComparisonItemField.packageItemCount, value),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListenableBuilder(
                    listenable: _details,
                    builder: (context, child) => DropdownButtonHideUnderline(
                      child: DropdownButton<UnitType>(
                        value: _details.packageUnits,
                        items: UnitType.filteredValues(_details.isFluidMeasure)
                            .map((e) => DropdownMenuItem<UnitType>(
                                  value: e,
                                  child: Text(e.pluralAbbreviation),
                                ))
                            .toList(),
                        onChanged: (value) => {
                          _changeUnitDropdown(
                              ComparisonItemField.packageUnits, value)
                        },
                      ),
                    ),
                  )),
            ),
          ]),
          if (_details.standardizedPrice > 0)
            Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListenableBuilder(
                        listenable: _details,
                        builder: (context, child) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(ApplicationStrings.unitPriceLabel),
                            Text(
                              _details.standardizedPriceDisplay,
                              textScaler: const TextScaler.linear(1.5),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
        ],
      );
    }
  }
}
