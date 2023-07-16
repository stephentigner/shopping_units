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
