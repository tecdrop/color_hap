// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:color_hap/models/color_item.dart';
import 'package:color_hap/models/color_type.dart';

void main() {
  group('ColorItem', () {
    group('Construction', () {
      test('should create ColorItem with all properties', () {
        const colorItem = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );

        expect(colorItem.type, equals(ColorType.basicColor));
        expect(colorItem.color.toARGB32(), equals(0xFFFF0000));
        expect(colorItem.name, equals('Red'));
        expect(colorItem.listPosition, equals(0));
      });

      test('should create ColorItem without name (attractive/true colors)', () {
        const colorItem = ColorItem(
          type: ColorType.attractiveColor,
          color: Color(0xFFABCDEF),
          name: null,
          listPosition: 500,
        );

        expect(colorItem.type, equals(ColorType.attractiveColor));
        expect(colorItem.color.toARGB32(), equals(0xFFABCDEF));
        expect(colorItem.name, isNull);
        expect(colorItem.listPosition, equals(500));
      });
    });

    group('Key generation', () {
      test('should generate correct key format for basic color', () {
        const colorItem = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );

        expect(colorItem.key, equals('BFF0000'));
        expect(colorItem.key[0], equals('B')); // Basic prefix
        expect(colorItem.key.substring(1), equals('FF0000')); // RGB hex
      });

      test('should generate correct key format for web color', () {
        const colorItem = ColorItem(
          type: ColorType.webColor,
          color: Color(0xFF00FF00),
          name: 'Lime',
          listPosition: 0,
        );

        expect(colorItem.key, equals('W00FF00'));
        expect(colorItem.key[0], equals('W')); // Web prefix
      });

      test('should generate correct key format for named color', () {
        const colorItem = ColorItem(
          type: ColorType.namedColor,
          color: Color(0xFF0000FF),
          name: 'Blue',
          listPosition: 100,
        );

        expect(colorItem.key, equals('N0000FF'));
        expect(colorItem.key[0], equals('N')); // Named prefix
      });

      test('should generate correct key format for attractive color', () {
        const colorItem = ColorItem(
          type: ColorType.attractiveColor,
          color: Color(0xFFABCDEF),
          name: null,
          listPosition: 500,
        );

        expect(colorItem.key, equals('AABCDEF'));
        expect(colorItem.key[0], equals('A')); // Attractive prefix
      });

      test('should generate correct key format for true color', () {
        const colorItem = ColorItem(
          type: ColorType.trueColor,
          color: Color(0xFF123456),
          name: null,
          listPosition: 1193046,
        );

        expect(colorItem.key, equals('T123456'));
        expect(colorItem.key[0], equals('T')); // True prefix
      });

      test('should pad hex values with leading zeros', () {
        const colorItem = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFF000001), // Very dark color
          name: 'Almost Black',
          listPosition: 0,
        );

        expect(colorItem.key, equals('B000001'));
        expect(colorItem.key.length, equals(7)); // Prefix + 6 hex digits
      });

      test('should use uppercase hex in key', () {
        const colorItem = ColorItem(
          type: ColorType.webColor,
          color: Color(0xFFABCDEF),
          name: 'Light Blue',
          listPosition: 0,
        );

        expect(colorItem.key, equals('WABCDEF'));
        expect(colorItem.key.substring(1), isNot(contains(RegExp('[a-f]'))));
      });
    });

    group('Compact JSON parsing', () {
      test('should parse compact JSON with name', () {
        final colorItem = ColorItem.fromCompactJson(
          ['FF0000', 'Red'],
          ColorType.basicColor,
          0,
        );

        expect(colorItem.type, equals(ColorType.basicColor));
        expect(colorItem.color.toARGB32(), equals(0xFFFF0000));
        expect(colorItem.name, equals('Red'));
        expect(colorItem.listPosition, equals(0));
      });

      test('should parse compact JSON without name', () {
        final colorItem = ColorItem.fromCompactJson(
          ['ABCDEF'],
          ColorType.attractiveColor,
          500,
        );

        expect(colorItem.type, equals(ColorType.attractiveColor));
        expect(colorItem.color.toARGB32(), equals(0xFFABCDEF));
        expect(colorItem.name, isNull);
        expect(colorItem.listPosition, equals(500));
      });

      test('should parse 3-digit hex in compact JSON', () {
        final colorItem = ColorItem.fromCompactJson(
          ['F00', 'Red'],
          ColorType.basicColor,
          0,
        );

        expect(colorItem.type, equals(ColorType.basicColor));
        expect(colorItem.color.toARGB32(), equals(0xFFFF0000));
        expect(colorItem.name, equals('Red'));
      });

      test('should parse hex with # prefix in compact JSON', () {
        final colorItem = ColorItem.fromCompactJson(
          ['#00FF00', 'Green'],
          ColorType.basicColor,
          1,
        );

        expect(colorItem.type, equals(ColorType.basicColor));
        expect(colorItem.color.toARGB32(), equals(0xFF00FF00));
        expect(colorItem.name, equals('Green'));
      });

      test('should handle lowercase hex in compact JSON', () {
        final colorItem = ColorItem.fromCompactJson(
          ['abcdef'],
          ColorType.attractiveColor,
          500,
        );

        expect(colorItem.color.toARGB32(), equals(0xFFABCDEF));
      });

      // Fail fast: Invalid data in controlled JSON files is a programming error, not user input.
      test('should throw when compact JSON has invalid hex', () {
        expect(
          () => ColorItem.fromCompactJson(['GGGGGG'], ColorType.attractiveColor, 0),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Equality and Set operations', () {
      test('should be equal when all properties match', () {
        const item1 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item2 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );

        expect(item1, equals(item2));
        expect(item1.hashCode, equals(item2.hashCode));
      });

      test('should not be equal when type differs', () {
        const item1 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item2 = ColorItem(
          type: ColorType.webColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should not be equal when color differs', () {
        const item1 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item2 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFF00FF00),
          name: 'Green',
          listPosition: 1,
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should not be equal when listPosition differs', () {
        const item1 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item2 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 1,
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should work correctly in Set (prevent duplicates)', () {
        const item1 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item2 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item3 = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFF00FF00),
          name: 'Green',
          listPosition: 1,
        );

        // Add items separately to test duplicate prevention
        final set = <ColorItem>{};
        set.add(item1);
        set.add(item2); // Duplicate - should not increase size
        set.add(item3);

        expect(set.length, equals(2)); // item1 and item2 are identical, only counted once
        expect(set.contains(item1), isTrue);
        expect(set.contains(item3), isTrue);
      });

      test('should support Set.contains() lookup', () {
        const red = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const green = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFF00FF00),
          name: 'Green',
          listPosition: 1,
        );
        const blue = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFF0000FF),
          name: 'Blue',
          listPosition: 2,
        );

        final favorites = {red, green};

        expect(favorites.contains(red), isTrue);
        expect(favorites.contains(green), isTrue);
        expect(favorites.contains(blue), isFalse);
      });

      test('should handle name differences correctly', () {
        // Same color and type, but different names - should still be different
        const item1 = ColorItem(
          type: ColorType.namedColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );
        const item2 = ColorItem(
          type: ColorType.namedColor,
          color: Color(0xFFFF0000),
          name: 'Scarlet',
          listPosition: 1,
        );

        expect(item1, isNot(equals(item2)));
      });
    });

    group('Edge cases', () {
      test('should handle black color (000000)', () {
        const colorItem = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFF000000),
          name: 'Black',
          listPosition: 0,
        );

        expect(colorItem.key, equals('B000000'));
        expect(colorItem.color.toARGB32(), equals(0xFF000000));
      });

      test('should handle white color (FFFFFF)', () {
        const colorItem = ColorItem(
          type: ColorType.basicColor,
          color: Color(0xFFFFFFFF),
          name: 'White',
          listPosition: 1,
        );

        expect(colorItem.key, equals('BFFFFFF'));
        expect(colorItem.color.toARGB32(), equals(0xFFFFFFFF));
      });

      test('should handle True Color with large list position', () {
        const colorItem = ColorItem(
          type: ColorType.trueColor,
          color: Color(0xFF123456),
          name: null,
          listPosition: 16777215, // Max 24-bit color
        );

        expect(colorItem.type, equals(ColorType.trueColor));
        expect(colorItem.listPosition, equals(16777215));
      });
    });
  });
}
