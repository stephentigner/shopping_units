enum UnitType {
  //imperial units
  ounces(
    fullTitle: "ounces",
    abbreviation: "oz",
    isFluidMeasure: false,
    isMetric: false,
    isSpecialUnit: false,
  ),
  pounds(
    fullTitle: "pounds",
    abbreviation: "lbs",
    isFluidMeasure: false,
    isMetric: false,
    isSpecialUnit: false,
  ),
  fluidOunces(
    fullTitle: "fluid ounces",
    abbreviation: "fl oz",
    isFluidMeasure: true,
    isMetric: false,
    isSpecialUnit: false,
  ),
  //metric units -- different scales of the same unit "redundantly" defined for convenience
  milligrams(
    fullTitle: "milligrams",
    abbreviation: "mg",
    isFluidMeasure: false,
    isMetric: true,
    isSpecialUnit: false,
  ),
  milliliters(
    fullTitle: "milliliters",
    abbreviation: "ml",
    isFluidMeasure: true,
    isMetric: true,
    isSpecialUnit: false,
  ),
  grams(
    fullTitle: "grams",
    abbreviation: "g",
    isFluidMeasure: false,
    isMetric: true,
    isSpecialUnit: false,
  ),
  liters(
    fullTitle: "liters",
    abbreviation: "l",
    isFluidMeasure: true,
    isMetric: true,
    isSpecialUnit: false,
  ),
  each(
    fullTitle: "items",
    abbreviation: "items",
    isFluidMeasure: false,
    isMetric: false,
    isSpecialUnit: true,
  );

  const UnitType({
    required this.fullTitle,
    required this.abbreviation,
    required this.isFluidMeasure,
    required this.isMetric,
    required this.isSpecialUnit,
  });

  final String fullTitle;
  final String abbreviation;
  final bool isFluidMeasure;
  final bool isMetric;
  final bool isSpecialUnit;
}
