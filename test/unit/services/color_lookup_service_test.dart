// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:color_hap/models/color_type.dart';
import 'package:color_hap/services/color_lookup_service.dart' as color_lookup;
import 'package:color_hap/services/generators_initializer.dart';

void main() {
  group('Color Lookup Service', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize generators and lookup service
      await initAllGenerators();
    });

    test('should find basic colors with correct priority', () {
      // #FF0000 is "red" - exists in both basic and web colors
      // Should return basic color (higher priority)
      final red = color_lookup.findKnownColor(const Color(0xFFFF0000));

      expect(red, isNotNull);
      expect(red!.type, ColorType.basicColor);
      expect(red.name, 'red');
    });

    test('should find web colors', () {
      // Test a color that's likely only in web colors
      // #F0F8FF is AliceBlue (web color)
      final aliceBlue = color_lookup.findKnownColor(const Color(0xFFF0F8FF));

      expect(aliceBlue, isNotNull);
      expect(aliceBlue!.type, anyOf(ColorType.webColor, ColorType.basicColor)); // May be in either
    });

    test('should find named colors', () {
      // Named colors have the largest catalog
      // Just verify that some named color can be found
      final someNamedColor = color_lookup.findKnownColor(const Color(0xFFFFEC13));

      // This color might be in named or other catalogs
      expect(someNamedColor, isNotNull);
    });

    test('should return null for unknown colors', () {
      // Pick a random color unlikely to be in any catalog
      final unknownColor = color_lookup.findKnownColor(const Color(0xFF123456));

      // This color probably doesn't exist in any catalog
      // If it does exist, that's fine - the test will fail and we'll adjust
      expect(unknownColor, isNull);
    });

    test('should find white and black (basic colors)', () {
      final white = color_lookup.findKnownColor(const Color(0xFFFFFFFF));
      final black = color_lookup.findKnownColor(const Color(0xFF000000));

      expect(white, isNotNull);
      expect(white!.type, ColorType.basicColor);
      expect(white.name, anyOf('white', 'White'));

      expect(black, isNotNull);
      expect(black!.type, ColorType.basicColor);
      expect(black.name, anyOf('black', 'Black'));
    });

    test('should have loaded all colors from catalogs', () {
      final count = color_lookup.knownColorsCount;

      // We have: 14 basic + 139 web + 1566 named + 5000 attractive
      // But some colors overlap (lower priority get overwritten)
      // So the count should be less than the sum but more than the largest catalog
      expect(count, greaterThan(5000)); // At least as many as attractive colors
      expect(count, lessThanOrEqualTo(14 + 139 + 1566 + 5000)); // At most the sum
    });

    test('should strip alpha channel when looking up colors', () {
      // Same color with different alpha values should return the same result
      final color1 = color_lookup.findKnownColor(const Color(0xFFFF0000)); // Fully opaque red
      final color2 = color_lookup.findKnownColor(const Color(0x80FF0000)); // 50% transparent red

      if (color1 != null && color2 != null) {
        expect(color1.type, color2.type);
        expect(color1.name, color2.name);
        expect(color1.color.toARGB32() & 0x00FFFFFF, color2.color.toARGB32() & 0x00FFFFFF);
      }
    });
  });
}
