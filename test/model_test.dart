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

import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/utils/unit_conversions.dart';

void main() {
  group('Item Details model tests', () {
    test('Simple unit price calculated correctly', () {
      final ItemDetails testItem = ItemDetails();
      testItem.packagePrice = 5;
      testItem.packageUnitsAmount = 2;

      expect(testItem.standardizedPrice, 5 / 2);
    });

    test('Unit price with conversion calculated correctly', () {
      final ItemDetails testItem = ItemDetails();
      const double packagePrice = 5;
      const double poundsAmount = 2;

      final convertedAmount = UnitConversions.convert(
          UnitType.pounds, UnitType.ounces, poundsAmount);

      testItem.packageUnits = UnitType.pounds;
      testItem.packagePrice = packagePrice;
      testItem.packageUnitsAmount = poundsAmount;

      expect(convertedAmount, isNotNull);
      expect(testItem.standardizedPrice, packagePrice / convertedAmount!);
    });

    test('Units change to default when mode switched to liquid', () {
      final ItemDetails testItem = ItemDetails();

      testItem.isFluidMeasure = true;
      expect(testItem.packageUnits, UnitType.defaultFluidUnit);
    });
  });
}
