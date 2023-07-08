enum UnitType {
  //imperial units
  ounces(
    fullTitle: "ounces",
    abbreviation: "oz",
    isFluidMeasure: false,
    isMetric: false,
  ),
  pounds(
    fullTitle: "pounds",
    abbreviation: "lbs",
    isFluidMeasure: false,
    isMetric: false,
  ),
  fluidOunces(
    fullTitle: "fluid ounces",
    abbreviation: "fl oz",
    isFluidMeasure: true,
    isMetric: false,
  ),
  //metric units -- different scales of the same unit "redundantly" defined for convenience
  milligrams(
    fullTitle: "milligrams",
    abbreviation: "mg",
    isFluidMeasure: false,
    isMetric: true,
  ),
  milliliters(
    fullTitle: "milliliters",
    abbreviation: "ml",
    isFluidMeasure: true,
    isMetric: true,
  ),
  grams(
    fullTitle: "grams",
    abbreviation: "g",
    isFluidMeasure: false,
    isMetric: true,
  ),
  liters(
    fullTitle: "liters",
    abbreviation: "l",
    isFluidMeasure: true,
    isMetric: true,
  ),
  kilograms(
    fullTitle: "kilograms",
    abbreviation: "kg",
    isFluidMeasure: false,
    isMetric: true,
  );

  const UnitType({
    required this.fullTitle,
    required this.abbreviation,
    required this.isFluidMeasure,
    required this.isMetric,
  });

  final String fullTitle;
  final String abbreviation;
  final bool isFluidMeasure;
  final bool isMetric;

  static Iterable<UnitType> get solidValues =>
      UnitType.values.where((element) => !element.isFluidMeasure);
  static Iterable<UnitType> get fluidValues =>
      UnitType.values.where((element) => element.isFluidMeasure);
  static UnitType get defaultSolidUnit => UnitType.solidValues.first;
  static UnitType get defaultFluidUnit => UnitType.fluidValues.first;

  static UnitType defaultUnit(bool isFluidMeasure) =>
      isFluidMeasure ? UnitType.defaultFluidUnit : UnitType.defaultSolidUnit;
  static Iterable<UnitType> filteredValues(bool isFluidMeasure) =>
      isFluidMeasure ? UnitType.fluidValues : UnitType.solidValues;
}
