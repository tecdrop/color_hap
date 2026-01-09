// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:color_hap/utils/color_utils.dart' as color_utils;

void main() {
  group('Color Utils - rgbHexToColor', () {
    test('should parse 6-digit hex without # prefix', () {
      final color = color_utils.rgbHexToColor('FF0000');
      expect(color, isNotNull);
      expect(color!.toARGB32(), equals(0xFFFF0000));
    });

    test('should parse 6-digit hex with # prefix', () {
      final color = color_utils.rgbHexToColor('#FF0000');
      expect(color, isNotNull);
      expect(color!.toARGB32(), equals(0xFFFF0000));
    });

    test('should parse 3-digit hex without # prefix', () {
      final color = color_utils.rgbHexToColor('F00');
      expect(color, isNotNull);
      expect(color!.toARGB32(), equals(0xFFFF0000));
    });

    test('should parse 3-digit hex with # prefix', () {
      final color = color_utils.rgbHexToColor('#F00');
      expect(color, isNotNull);
      expect(color!.toARGB32(), equals(0xFFFF0000));
    });

    test('should handle lowercase hex', () {
      final color = color_utils.rgbHexToColor('ff0000');
      expect(color, isNotNull);
      expect(color!.toARGB32(), equals(0xFFFF0000));
    });

    test('should handle mixed case hex', () {
      final color = color_utils.rgbHexToColor('Ff00Aa');
      expect(color, isNotNull);
      expect(color!.toARGB32(), equals(0xFFFF00AA));
    });

    group('Edge cases', () {
      test('should parse black (000000)', () {
        final color = color_utils.rgbHexToColor('000000');
        expect(color, isNotNull);
        expect(color!.toARGB32(), equals(0xFF000000));
      });

      test('should parse white (FFFFFF)', () {
        final color = color_utils.rgbHexToColor('FFFFFF');
        expect(color, isNotNull);
        expect(color!.toARGB32(), equals(0xFFFFFFFF));
      });

      test('should parse black short form (000)', () {
        final color = color_utils.rgbHexToColor('000');
        expect(color, isNotNull);
        expect(color!.toARGB32(), equals(0xFF000000));
      });

      test('should parse white short form (FFF)', () {
        final color = color_utils.rgbHexToColor('FFF');
        expect(color, isNotNull);
        expect(color!.toARGB32(), equals(0xFFFFFFFF));
      });

      test('should parse gray (808080)', () {
        final color = color_utils.rgbHexToColor('808080');
        expect(color, isNotNull);
        expect(color!.toARGB32(), equals(0xFF808080));
      });
    });

    group('Invalid input', () {
      test('should return null for null input', () {
        final color = color_utils.rgbHexToColor(null);
        expect(color, isNull);
      });

      test('should return null for invalid hex characters', () {
        final color = color_utils.rgbHexToColor('GGGGGG');
        expect(color, isNull);
      });

      test('should return null for wrong length', () {
        final color1 = color_utils.rgbHexToColor('FF');
        final color2 = color_utils.rgbHexToColor('FFFF');
        final color3 = color_utils.rgbHexToColor('FFFFFFF');
        expect(color1, isNull);
        expect(color2, isNull);
        expect(color3, isNull);
      });

      test('should return null for empty string', () {
        final color = color_utils.rgbHexToColor('');
        expect(color, isNull);
      });

      test('should return null for special characters', () {
        final color = color_utils.rgbHexToColor('FF@000');
        expect(color, isNull);
      });

      // No trimming: This is a low-level parser. Input sanitization should happen at UI layer.
      test('should return null for hex with whitespace', () {
        expect(color_utils.rgbHexToColor(' FF0000'), isNull);
        expect(color_utils.rgbHexToColor('FF0000 '), isNull);
        expect(color_utils.rgbHexToColor(' #FF0000 '), isNull);
      });
    });
  });

  group('Color Utils - toHexString', () {
    test('should format red correctly with # prefix', () {
      const color = Color(0xFFFF0000);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#FF0000'));
    });

    test('should format green correctly with # prefix', () {
      const color = Color(0xFF00FF00);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#00FF00'));
    });

    test('should format blue correctly with # prefix', () {
      const color = Color(0xFF0000FF);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#0000FF'));
    });

    test('should format black correctly with # prefix', () {
      const color = Color(0xFF000000);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#000000'));
    });

    test('should format white correctly with # prefix', () {
      const color = Color(0xFFFFFFFF);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#FFFFFF'));
    });

    test('should format gray correctly with # prefix', () {
      const color = Color(0xFF808080);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#808080'));
    });

    test('should format without # prefix when withHash is false', () {
      const color = Color(0xFFFF0000);
      final hex = color_utils.toHexString(color, withHash: false);
      expect(hex, equals('FF0000'));
      expect(hex, isNot(startsWith('#')));
    });

    test('should use uppercase letters', () {
      const color = Color(0xFFABCDEF);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#ABCDEF'));
      expect(hex.substring(1), isNot(contains(RegExp('[a-f]')))); // No lowercase (after #)
    });

    test('should pad with leading zeros', () {
      const color = Color(0xFF000102);
      final hex = color_utils.toHexString(color);
      expect(hex, equals('#000102'));
      expect(hex.length, equals(7)); // # + 6 digits
    });

    test('should ignore alpha channel', () {
      const color1 = Color(0x00FF0000); // Transparent red
      const color2 = Color(0x80FF0000); // Semi-transparent red
      const color3 = Color(0xFFFF0000); // Opaque red

      final hex1 = color_utils.toHexString(color1);
      final hex2 = color_utils.toHexString(color2);
      final hex3 = color_utils.toHexString(color3);

      expect(hex1, equals('#FF0000'));
      expect(hex2, equals('#FF0000'));
      expect(hex3, equals('#FF0000'));
    });
  });

  group('Color Utils - Round-trip conversion', () {
    test('should convert to hex and back correctly', () {
      const original = Color(0xFFABCDEF);
      final hex = color_utils.toHexString(original);
      final converted = color_utils.rgbHexToColor(hex);

      expect(converted, isNotNull);
      expect(converted!.toARGB32(), equals(original.toARGB32()));
    });

    test('should handle all basic colors', () {
      const colors = [
        Color(0xFF000000), // Black
        Color(0xFFFFFFFF), // White
        Color(0xFFFF0000), // Red
        Color(0xFF00FF00), // Green
        Color(0xFF0000FF), // Blue
        Color(0xFFFFFF00), // Yellow
        Color(0xFFFF00FF), // Magenta
        Color(0xFF00FFFF), // Cyan
      ];

      for (final original in colors) {
        final hex = color_utils.toHexString(original);
        final converted = color_utils.rgbHexToColor(hex);
        expect(converted!.toARGB32(), equals(original.toARGB32()));
      }
    });

    test('should handle short hex format round-trip', () {
      const original = Color(0xFFFF0000);
      final converted = color_utils.rgbHexToColor('F00');

      expect(converted, isNotNull);
      expect(converted!.toARGB32(), equals(original.toARGB32()));
    });
  });
}
