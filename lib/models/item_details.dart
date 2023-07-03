import 'package:shopping_units/enums/unit_type.dart';

class ItemDetails {
  String name = "";
  double packagePrice = 0.0;
  double packageUnitsAmount = 0.0;
  UnitType packageUnits = UnitType.values.first;
  int itemCount = 1;
  double itemUnitsAmount = 0.0;
  UnitType itemUnits = UnitType.values.first;
  double standardizedPrice = 0.0;
  UnitType standardizedUnits = UnitType.values.first;
}
