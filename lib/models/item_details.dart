import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/utils/application_strings.dart';
import 'package:shopping_units/utils/unit_conversions.dart';

class ItemDetails {
  bool _isFluidMeasure = false;

  UniqueKey key = UniqueKey();
  bool isDeleted = false;
  int deletionNoticeTimeRemaining = 0;
  Timer? deletionNoticeTimer;

  String name = "";
  double? packagePrice;
  double? packageUnitsAmount;
  UnitType packageUnits = UnitType.defaultSolidUnit;
  UnitType standardizedUnits = UnitType.defaultSolidUnit;

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

  String get deletedItemLabel => name.isNotEmpty
      ? '"${name}" deleted'
      : ApplicationStrings.deletedItemLabel;
}
