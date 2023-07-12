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

    return packagePrice != null &&
            packagePrice! > 0 &&
            convertedAmount != null &&
            convertedAmount > 0
        ? packagePrice! / convertedAmount
        : 0;
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

  String get standardizedPriceDisplay => standardizedPrice > 0
      ? "\$${standardizedPrice.toStringAsFixed(2)}/${standardizedUnits.abbreviation}"
      : "";

  String get deletedItemLabel =>
      name.isNotEmpty ? '"$name" deleted' : ApplicationStrings.deletedItemLabel;
}
