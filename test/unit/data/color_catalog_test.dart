// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license.

import 'package:flutter_test/flutter_test.dart';

import 'package:color_hap/models/color_item.dart';
import 'package:color_hap/models/color_type.dart';
import 'package:color_hap/services/generators_initializer.dart';

void main() {
  group('Color Catalog Validation', () {
    late Map<ColorType, List<ColorItem>> colorCatalogs;

    setUpAll(() async {
      // Load all color catalogs once for all tests
      TestWidgetsFlutterBinding.ensureInitialized();

      final generators = await initAllGenerators();

      // Extract color lists from generators (excluding mixedColor and trueColor)
      colorCatalogs = {
        .basicColor: generators[ColorType.basicColor]!.toList(),
        .webColor: generators[ColorType.webColor]!.toList(),
        .namedColor: generators[ColorType.namedColor]!.toList(),
        .attractiveColor: generators[ColorType.attractiveColor]!.toList(),
      };
    });

    test('attractive colors should not duplicate basic/web/named colors', () {
      // Create a set of all known color codes (basic, web, named)
      final knownColorCodes = <int>{
        ...colorCatalogs[ColorType.basicColor]!.map((c) => c.color.toARGB32()),
        ...colorCatalogs[ColorType.webColor]!.map((c) => c.color.toARGB32()),
        ...colorCatalogs[ColorType.namedColor]!.map((c) => c.color.toARGB32()),
      };

      // Check for duplicates in attractive colors
      final duplicates = <String>[];
      for (final colorItem in colorCatalogs[ColorType.attractiveColor]!) {
        if (knownColorCodes.contains(colorItem.color.toARGB32())) {
          final hex = colorItem.color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
          duplicates.add('0x$hex');
        }
      }

      // Assert no duplicates found
      expect(
        duplicates,
        isEmpty,
        reason:
            'Found ${duplicates.length} attractive colors that duplicate basic/web/named colors: '
            '${duplicates.take(10).join(', ')}${duplicates.length > 10 ? '...' : ''}',
      );
    });

    test('all color codes should be valid 24-bit RGB (0x00000000 to 0x00FFFFFF)', () {
      for (final entry in colorCatalogs.entries) {
        final colorType = entry.key;
        final colors = entry.value;

        for (final colorItem in colors) {
          final colorValue = colorItem.color.toARGB32() & 0x00FFFFFF; // Remove alpha channel

          expect(
            colorValue,
            inInclusiveRange(0x00000000, 0x00FFFFFF),
            reason: 'Invalid color value in ${colorType.name}: 0x${colorValue.toRadixString(16)}',
          );
        }
      }
    });

    test('named colors should have non-empty names', () {
      // Check basic, web, and named colors (these should have names)
      // Note: Attractive colors only have hex codes, no names
      final typesToCheck = [
        ColorType.basicColor,
        ColorType.webColor,
        ColorType.namedColor,
      ];

      for (final colorType in typesToCheck) {
        final colors = colorCatalogs[colorType]!;

        for (final colorItem in colors) {
          expect(
            colorItem.name,
            isNotNull,
            reason:
                'Color in ${colorType.name} has null name at position ${colorItem.listPosition}',
          );

          expect(
            colorItem.name!.trim(),
            isNotEmpty,
            reason:
                'Color in ${colorType.name} has empty name at position ${colorItem.listPosition}',
          );
        }
      }
    });

    test('attractive colors should not have names (only hex codes)', () {
      final colors = colorCatalogs[ColorType.attractiveColor]!;

      for (final colorItem in colors) {
        expect(
          colorItem.name,
          isNull,
          reason: 'Attractive color at position ${colorItem.listPosition} should not have a name',
        );
      }
    });

    test('all catalogs should have positive color counts', () {
      expect(
        colorCatalogs[ColorType.basicColor]!.length,
        greaterThan(0),
        reason: 'Basic colors catalog is empty',
      );
      expect(
        colorCatalogs[ColorType.webColor]!.length,
        greaterThan(0),
        reason: 'Web colors catalog is empty',
      );
      expect(
        colorCatalogs[ColorType.namedColor]!.length,
        greaterThan(0),
        reason: 'Named colors catalog is empty',
      );
      expect(
        colorCatalogs[ColorType.attractiveColor]!.length,
        greaterThan(0),
        reason: 'Attractive colors catalog is empty',
      );
    });

    test('color catalogs should have expected minimum counts', () {
      // Based on current data files
      expect(
        colorCatalogs[ColorType.basicColor]!.length,
        greaterThanOrEqualTo(10),
        reason: 'Basic colors should have at least 10 colors',
      );
      expect(
        colorCatalogs[ColorType.webColor]!.length,
        greaterThanOrEqualTo(100),
        reason: 'Web colors should have at least 100 colors',
      );
      expect(
        colorCatalogs[ColorType.namedColor]!.length,
        greaterThanOrEqualTo(1000),
        reason: 'Named colors should have at least 1000 colors',
      );
      expect(
        colorCatalogs[ColorType.attractiveColor]!.length,
        greaterThanOrEqualTo(5000),
        reason: 'Attractive colors should have at least 5000 colors',
      );
    });

    test('list positions should be sequential and zero-indexed', () {
      for (final entry in colorCatalogs.entries) {
        final colorType = entry.key;
        final colors = entry.value;

        for (var i = 0; i < colors.length; i++) {
          expect(
            colors[i].listPosition,
            equals(i),
            reason: 'List position mismatch in ${colorType.name} at index $i',
          );
        }
      }
    });

    test('all colors within a catalog should have the correct color type', () {
      for (final entry in colorCatalogs.entries) {
        final expectedType = entry.key;
        final colors = entry.value;

        for (final colorItem in colors) {
          expect(
            colorItem.type,
            equals(expectedType),
            reason:
                'Color at position ${colorItem.listPosition} has wrong type: '
                '${colorItem.type.name} (expected ${expectedType.name})',
          );
        }
      }
    });
  });
}

// Extension to convert generator to list for testing
extension on dynamic {
  List<ColorItem> toList() {
    final items = <ColorItem>[];
    final count = this.length as int;
    for (var i = 0; i < count; i++) {
      items.add(this.elementAt(i));
    }
    return items;
  }
}
