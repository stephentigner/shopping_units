/*
Copyright (C) 2025 Stephen Tigner

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

import 'dart:io';
import 'dart:developer' as developer;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shopping_units/enums/unit_type.dart';

class UnitMeasurement {
  final double value;
  final UnitType unit;
  final TextBlock? textBlock; // The text block containing the measurement

  UnitMeasurement(this.value, this.unit, [this.textBlock]);
}

class RecognitionResult {
  final List<TextBlock> allBlocks;
  final UnitMeasurement? measurement;

  RecognitionResult(this.allBlocks, this.measurement);
}

class UnitRecognition {
  static final _textRecognizer = TextRecognizer();

  // Map common variations of unit measurements to our UnitType enum
  static final Map<RegExp, UnitType> _unitPatterns = {
    // Fluid ounces - handle OCR misreads of 'O' as '0'
    RegExp(r'fl\.?\s*[o0]z\.?|fl[o0]z\.?|fluid\s*[o0]z\.?|fluid\s*[o0]unces?',
        caseSensitive: false): UnitType.fluidOunces,

    // Regular ounces - exclude fluid oz and percentages, handle OCR misreads
    RegExp(r'(?<!fl\.?\s*)(?<!fluid\s*)(?<!%)\s*[o0]z\.?|[o0]unces?(?!\s*fl)',
        caseSensitive: false): UnitType.ounces,

    // Pounds
    RegExp(r'lb\.?s?|pounds?', caseSensitive: false): UnitType.pounds,

    // Milliliters - handle parentheses
    RegExp(r'(?:\(?\s*ml\.?\s*\)?|\(?\s*milliliters?\s*\)?)',
        caseSensitive: false): UnitType.milliliters,

    // Liters
    RegExp(r'l\.?|liters?', caseSensitive: false): UnitType.liters,

    // Milligrams
    RegExp(r'mg\.?|milligrams?', caseSensitive: false): UnitType.milligrams,

    // Grams
    RegExp(r'g\.?|grams?(?!\w)', caseSensitive: false): UnitType.grams,

    // Kilograms
    RegExp(r'kg\.?|kilograms?', caseSensitive: false): UnitType.kilograms,
  };

  // Simple number pattern that matches integers and decimals
  static final _numberPattern = RegExp(r'(\d+\.?\d*)');

  /// Extracts the first valid measurement from a text string
  /// Returns null if no valid measurement is found
  static UnitMeasurement? extractMeasurement(String text, [TextBlock? block]) {
    // Add debug logging to see what we're processing
    developer.log(
      'Processing text for measurement',
      name: 'UnitRecognition',
      error: text,
    );

    // Look for each unit pattern in the text
    for (var entry in _unitPatterns.entries) {
      final unitMatch = entry.key.firstMatch(text);
      if (unitMatch != null) {
        // Search for numbers in the text before the unit
        final beforeUnit = text.substring(0, unitMatch.start).trim();

        // Find the last number before the unit
        final numbers = _numberPattern.allMatches(beforeUnit).toList();
        if (numbers.isNotEmpty) {
          final lastNumber = numbers.last;
          final value = double.tryParse(lastNumber.group(1) ?? '');
          if (value != null && value > 0) {
            // Log successful match
            developer.log(
              'Found measurement',
              name: 'UnitRecognition',
              error: 'Value: $value, Unit: ${entry.value.abbreviation}',
            );
            return UnitMeasurement(value, entry.value, block);
          }
        }
      }
    }
    return null;
  }

  /// Processes an image file and returns the recognized text blocks and measurement
  /// Returns null if no valid measurement is found
  static Future<RecognitionResult> recognizeUnits(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      UnitMeasurement? foundMeasurement;

      // Process each block of text
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final measurement = extractMeasurement(line.text, block);
          if (measurement != null) {
            foundMeasurement = measurement;
            break;
          }
        }
        if (foundMeasurement != null) break;
      }

      return RecognitionResult(recognizedText.blocks, foundMeasurement);
    } catch (e) {
      developer.log(
        'Error during text recognition',
        error: e,
        name: 'UnitRecognition',
        level: 1000, // Equivalent to severe/error level
      );
      return RecognitionResult([], null);
    }
  }

  /// Cleans up resources
  static void dispose() {
    _textRecognizer.close();
  }
}
