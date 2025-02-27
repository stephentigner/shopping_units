import 'dart:io';
import 'dart:developer' as developer;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shopping_units/enums/unit_type.dart';

class UnitMeasurement {
  final double value;
  final UnitType unit;

  UnitMeasurement(this.value, this.unit);
}

class UnitRecognition {
  static final _textRecognizer = TextRecognizer();

  // Map common variations of unit measurements to our UnitType enum
  static final Map<RegExp, UnitType> _unitPatterns = {
    // Fluid ounces
    RegExp(r'fl\.?\s*o?z\.?', caseSensitive: false): UnitType.fluidOunces,
    RegExp(r'fluid\s+o?z\.?', caseSensitive: false): UnitType.fluidOunces,

    // Regular ounces
    RegExp(r'(?<!fl\.?\s*)o?z\.?(?!\s*fl)', caseSensitive: false):
        UnitType.ounces,
    RegExp(r'ounces?(?!\s*fluid)', caseSensitive: false): UnitType.ounces,

    // Pounds
    RegExp(r'lb\.?s?', caseSensitive: false): UnitType.pounds,
    RegExp(r'pounds?', caseSensitive: false): UnitType.pounds,

    // Milliliters
    RegExp(r'ml\.?', caseSensitive: false): UnitType.milliliters,
    RegExp(r'millili?te?rs?', caseSensitive: false): UnitType.milliliters,

    // Liters
    RegExp(r'l\.?(?!b)', caseSensitive: false): UnitType.liters,
    RegExp(r'li?te?rs?', caseSensitive: false): UnitType.liters,

    // Milligrams
    RegExp(r'mg\.?', caseSensitive: false): UnitType.milligrams,
    RegExp(r'milligrams?', caseSensitive: false): UnitType.milligrams,

    // Grams
    RegExp(r'g\.?(?!al)', caseSensitive: false): UnitType.grams,
    RegExp(r'grams?', caseSensitive: false): UnitType.grams,

    // Kilograms
    RegExp(r'kg\.?', caseSensitive: false): UnitType.kilograms,
    RegExp(r'kilograms?', caseSensitive: false): UnitType.kilograms,
  };

  // Pattern to match a number (including decimals) followed by potential spaces
  static final _numberPattern = RegExp(r'(\d+\.?\d*)[\s]*');

  /// Processes an image file and returns the first recognized unit measurement
  /// Returns null if no valid measurement is found
  static Future<UnitMeasurement?> recognizeUnits(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      // Process each block of text
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final measurement = _extractMeasurement(line.text);
          if (measurement != null) {
            return measurement;
          }
        }
      }
    } catch (e) {
      developer.log(
        'Error during text recognition',
        error: e,
        name: 'UnitRecognition',
        level: 1000, // Equivalent to severe/error level
      );
    }
    return null;
  }

  /// Extracts the first valid measurement from a text string
  /// Returns null if no valid measurement is found
  static UnitMeasurement? _extractMeasurement(String text) {
    // Look for each unit pattern in the text
    for (var entry in _unitPatterns.entries) {
      final unitMatch = entry.key.firstMatch(text);
      if (unitMatch != null) {
        // Look for a number before the unit
        final numberMatch = _numberPattern.firstMatch(
          text.substring(0, unitMatch.start).trim(),
        );

        if (numberMatch != null) {
          final value = double.tryParse(numberMatch.group(1) ?? '');
          if (value != null && value > 0) {
            return UnitMeasurement(value, entry.value);
          }
        }
      }
    }
    return null;
  }

  /// Cleans up resources
  static void dispose() {
    _textRecognizer.close();
  }
}
