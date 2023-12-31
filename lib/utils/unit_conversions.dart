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

import 'package:units_converter/units_converter.dart';

import '../enums/unit_type.dart';

class UnitConversions {
  static const Map<UnitType, MASS> _solidUnitMap = {
    UnitType.ounces: MASS.ounces,
    UnitType.pounds: MASS.pounds,
    UnitType.milligrams: MASS.milligrams,
    UnitType.grams: MASS.grams,
    UnitType.kilograms: MASS.kilograms,
  };

  static const Map<UnitType, VOLUME> _fluidUnitMap = {
    UnitType.fluidOunces: VOLUME.usFluidOunces,
    UnitType.milliliters: VOLUME.milliliters,
    UnitType.liters: VOLUME.liters
  };

  static double? convert(UnitType fromUnit, UnitType toUnit, double amount) {
    double? convertedAmount;

    if (fromUnit.isFluidMeasure == toUnit.isFluidMeasure) {
      if (fromUnit.isFluidMeasure) {
        convertedAmount = _convertFluidUnits(fromUnit, toUnit, amount);
      } else {
        convertedAmount = _convertSolidUnits(fromUnit, toUnit, amount);
      }
    }

    return convertedAmount;
  }

  static double? _convertSolidUnits(
      UnitType fromUnit, UnitType toUnit, double amount) {
    MASS? fromMass = _solidUnitMap[fromUnit];
    MASS? toMass = _solidUnitMap[toUnit];
    double? convertedAmount;

    if (fromMass != null && toMass != null) {
      convertedAmount = amount.convertFromTo(fromMass, toMass);
    }

    return convertedAmount;
  }

  static double? _convertFluidUnits(
      UnitType fromUnit, UnitType toUnit, double amount) {
    VOLUME? fromMass = _fluidUnitMap[fromUnit];
    VOLUME? toMass = _fluidUnitMap[toUnit];
    double? convertedAmount;

    if (fromMass != null && toMass != null) {
      convertedAmount = amount.convertFromTo(fromMass, toMass);
    }

    return convertedAmount;
  }
}
