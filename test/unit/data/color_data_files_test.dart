// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license.

import 'dart:convert' as convert;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

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

  group('Color data files uniqueness validation', () {
    test('basic_colors.json has no duplicate hex codes', () async {
      await _validateUniqueHexCodes('data/colors/basic_colors.json');
    });

    test('basic_colors.json has no duplicate names (case-insensitive)', () async {
      await _validateUniqueNames('data/colors/basic_colors.json');
    });

    test('web_colors.json has no duplicate hex codes', () async {
      await _validateUniqueHexCodes('data/colors/web_colors.json');
    });

    test('web_colors.json has no duplicate names (case-insensitive)', () async {
      await _validateUniqueNames('data/colors/web_colors.json');
    });

    test('named_colors.json has no duplicate hex codes', () async {
      await _validateUniqueHexCodes('data/colors/named_colors.json');
    });

    test('named_colors.json has no duplicate names (case-insensitive)', () async {
      await _validateUniqueNames('data/colors/named_colors.json');
    });

    test('attractive_colors.json has no duplicate hex codes', () async {
      await _validateUniqueHexCodes('data/colors/attractive_colors.json');
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

/// Validates that a color data file has no duplicate hex codes.
///
/// Reports the specific hex code that is duplicated and at which indices.
Future<void> _validateUniqueHexCodes(String path) async {
  final colorDataString = await rootBundle.loadString(path);
  final colorData = convert.jsonDecode(colorDataString) as List;

  final seenHexCodes = <String, int>{};

  for (var i = 0; i < colorData.length; i++) {
    final item = colorData[i] as List;
    final hexCode = item[0] as String;

    if (seenHexCodes.containsKey(hexCode)) {
      fail(
        'Duplicate hex code "$hexCode" found at index $i '
        '(previously seen at index ${seenHexCodes[hexCode]})',
      );
    }

    seenHexCodes[hexCode] = i;
  }
}

/// Validates that a color data file has no duplicate names (case-insensitive).
///
/// Reports the specific name that is duplicated and at which indices.
Future<void> _validateUniqueNames(String path) async {
  final colorDataString = await rootBundle.loadString(path);
  final colorData = convert.jsonDecode(colorDataString) as List;

  final seenNames = <String, int>{};

  for (var i = 0; i < colorData.length; i++) {
    final item = colorData[i] as List;

    // Skip if this item doesn't have a name (attractive colors)
    if (item.length < 2) continue;

    final name = item[1] as String;
    final normalizedName = name.toLowerCase();

    if (seenNames.containsKey(normalizedName)) {
      fail(
        'Duplicate name "$name" (case-insensitive) found at index $i '
        '(previously seen as "${colorData[seenNames[normalizedName]!][1]}" at index ${seenNames[normalizedName]})',
      );
    }

    seenNames[normalizedName] = i;
  }
}
