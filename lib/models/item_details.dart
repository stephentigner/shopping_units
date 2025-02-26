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
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/utils/application_strings.dart';
import 'package:shopping_units/utils/unit_conversions.dart';

class ItemDetails with ChangeNotifier {
  String _name = "";
  double? _packagePrice;
  double? _packageUnitsAmount;
  UnitType _packageUnits = UnitType.defaultSolidUnit;
  UnitType _standardizedUnits = UnitType.defaultSolidUnit;
  bool _isFluidMeasure = false;
  bool _isMultiPack = false;
  int _packageItemCount = 1;

  UniqueKey key = UniqueKey();
  bool isDeleted = false;
  int deletionNoticeTimeRemaining = 0;
  Timer? deletionNoticeTimer;

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  double? get packagePrice => _packagePrice;
  set packagePrice(double? value) {
    _packagePrice = value;
    notifyListeners();
  }

  double? get packageUnitsAmount => _packageUnitsAmount;
  set packageUnitsAmount(double? value) {
    _packageUnitsAmount = value;
    notifyListeners();
  }

  UnitType get packageUnits => _packageUnits;
  set packageUnits(UnitType value) {
    _packageUnits = value;
    notifyListeners();
  }

  UnitType get standardizedUnits => _standardizedUnits;
  set standardizedUnits(UnitType value) {
    _standardizedUnits = value;
    notifyListeners();
  }

  double get standardizedPrice {
    double? convertedAmount;

    if (packageUnits != standardizedUnits && packageUnitsAmount != null) {
      convertedAmount = UnitConversions.convert(
          packageUnits, standardizedUnits, packageUnitsAmount!);
    } else {
      convertedAmount = packageUnitsAmount;
    }

    if (packagePrice != null &&
        packagePrice! > 0 &&
        convertedAmount != null &&
        convertedAmount > 0) {
      // For multi-packs, first get the price per individual item
      double pricePerItem =
          isMultiPack ? packagePrice! / packageItemCount : packagePrice!;
      return pricePerItem / convertedAmount;
    } else {
      return 0;
    }
  }

  bool get isFluidMeasure => _isFluidMeasure;
  set isFluidMeasure(bool value) {
    _isFluidMeasure = value;

    if (packageUnits.isFluidMeasure != value) {
      packageUnits = UnitType.defaultUnit(value);
    }

    if (standardizedUnits.isFluidMeasure != value) {
      standardizedUnits = UnitType.defaultUnit(value);
    }
  }

  bool get isMultiPack => _isMultiPack;
  set isMultiPack(bool value) {
    _isMultiPack = value;
    notifyListeners();
  }

  int get packageItemCount => _packageItemCount;
  set packageItemCount(int value) {
    _packageItemCount = value < 1 ? 1 : value;
    notifyListeners();
  }

  String get standardizedPriceDisplay => standardizedPrice > 0
      ? "${ApplicationStrings.currencySymbol}${standardizedPrice.toStringAsFixed(2)}/${standardizedUnits.abbreviation}"
      : "";

  String get deletedItemLabel =>
      name.isNotEmpty ? '"$name" deleted' : ApplicationStrings.deletedItemLabel;
}
