import 'dart:convert' as convert;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Color data files format validation', () {
    test('basic_colors.json has correct format and count', () async {
      await _validateColorDataFile(
        path: 'data/colors/basic_colors.json',
        expectedCount: 14,
        hasNames: true,
      );
    });

    test('web_colors.json has correct format and count', () async {
      await _validateColorDataFile(
        path: 'data/colors/web_colors.json',
        expectedCount: 139,
        hasNames: true,
      );
    });

    test('named_colors.json has correct format and count', () async {
      await _validateColorDataFile(
        path: 'data/colors/named_colors.json',
        expectedCount: 1566,
        hasNames: true,
      );
    });

    test('attractive_colors.json has correct format and count', () async {
      await _validateColorDataFile(
        path: 'data/colors/attractive_colors.json',
        expectedCount: 5000,
        hasNames: false,
      );
    });
  });
}

/// Validates a color data file's format and count.
///
/// Checks that:
/// - File can be loaded
/// - JSON is a valid array
/// - Each item is an array
/// - First element is a valid 6-character hex color code (without #)
/// - Second element is a non-empty string (if [hasNames] is true)
/// - Total count matches [expectedCount]
Future<void> _validateColorDataFile({
  required String path,
  required int expectedCount,
  required bool hasNames,
}) async {
  // Load the file
  final colorDataString = await rootBundle.loadString(path);
  expect(colorDataString, isNotEmpty, reason: 'File should not be empty');

  // Parse JSON
  final decodedColorData = convert.jsonDecode(colorDataString);
  expect(decodedColorData, isA<List>(), reason: 'JSON should be an array');

  final colorData = decodedColorData as List;

  // Check count
  expect(
    colorData.length,
    expectedCount,
    reason: 'File should contain exactly $expectedCount colors',
  );

  // Validate format of each item
  for (var i = 0; i < colorData.length; i++) {
    final item = colorData[i];

    // Should be an array
    expect(
      item,
      isA<List>(),
      reason: 'Item at index $i should be an array',
    );

    final itemArray = item as List;

    // Should have 1 or 2 elements
    if (hasNames) {
      expect(
        itemArray.length,
        2,
        reason: 'Item at index $i should have exactly 2 elements (hex code and name)',
      );
    } else {
      expect(
        itemArray.length,
        1,
        reason: 'Item at index $i should have exactly 1 element (hex code only)',
      );
    }

    // First element should be a valid 6-character hex color code
    final hexCode = itemArray[0];
    expect(
      hexCode,
      isA<String>(),
      reason: 'Hex code at index $i should be a string',
    );
    expect(
      hexCode,
      matches(RegExp(r'^[0-9A-F]{6}$')),
      reason: 'Hex code at index $i should be 6 uppercase hex characters without #',
    );

    // Second element should be a non-empty string (if has names)
    if (hasNames) {
      final name = itemArray[1];
      expect(
        name,
        isA<String>(),
        reason: 'Name at index $i should be a string',
      );
      expect(
        (name as String).isNotEmpty,
        isTrue,
        reason: 'Name at index $i should not be empty',
      );
    }
  }
}
