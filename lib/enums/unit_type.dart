enum UnitType {
  //imperial units
  ounces(
    fullTitle: "ounce",
    pluralTitle: "ounces",
    abbreviation: "oz",
    pluralAbbreviation: "oz",
    isFluidMeasure: false,
    isMetric: false,
  ),
  pounds(
    fullTitle: "pound",
    pluralTitle: "pounds",
    abbreviation: "lb",
    pluralAbbreviation: "lbs",
    isFluidMeasure: false,
    isMetric: false,
  ),
  fluidOunces(
    fullTitle: "fluid ounce",
    pluralTitle: "fluid ounces",
    abbreviation: "fl oz",
    pluralAbbreviation: "fl oz",
    isFluidMeasure: true,
    isMetric: false,
  ),
  //metric units -- different scales of the same unit "redundantly" defined for convenience
  milligrams(
    fullTitle: "milligram",
    pluralTitle: "milligrams",
    abbreviation: "mg",
    pluralAbbreviation: "mg",
    isFluidMeasure: false,
    isMetric: true,
  ),
  milliliters(
    fullTitle: "milliliter",
    pluralTitle: "milliliters",
    abbreviation: "ml",
    pluralAbbreviation: "ml",
    isFluidMeasure: true,
    isMetric: true,
  ),
  grams(
    fullTitle: "gram",
    pluralTitle: "grams",
    abbreviation: "g",
    pluralAbbreviation: "g",
    isFluidMeasure: false,
    isMetric: true,
  ),
  liters(
    fullTitle: "liter",
    pluralTitle: "liters",
    abbreviation: "l",
    pluralAbbreviation: "l",
    isFluidMeasure: true,
    isMetric: true,
  ),
  kilograms(
    fullTitle: "kilogram",
    pluralTitle: "kilograms",
    abbreviation: "kg",
    pluralAbbreviation: "kg",
    isFluidMeasure: false,
    isMetric: true,
  );

  const UnitType({
    required this.fullTitle,
    required this.pluralTitle,
    required this.abbreviation,
    required this.pluralAbbreviation,
    required this.isFluidMeasure,
    required this.isMetric,
  });

  final String fullTitle;
  final String pluralTitle;
  final String abbreviation;
  final String pluralAbbreviation;
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
