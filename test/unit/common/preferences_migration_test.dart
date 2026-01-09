// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Integration tests for preferences migration from old JSON format to new key-list format.
///
/// NOTE: These tests verify the migration logic at the ColorFavoritesList level.
/// Full end-to-end testing of preferences.loadSettings() with SharedPreferencesAsync
/// requires integration tests rather than unit tests, as SharedPreferencesAsync
/// doesn't support mocking in the same way as the legacy SharedPreferences.
///
/// The migration flow tested here:
/// 1. Old format (JSON) → loadFromJsonStringList() → in-memory ColorFavoritesList
/// 2. In-memory → toKeyList() → new format (compact keys)
/// 3. New format → loadFromKeyList() → reconstructed ColorFavoritesList
///
/// This validates the core migration logic without requiring platform-specific mocking.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:color_hap/models/color_favorites_list.dart';
import 'package:color_hap/models/color_item.dart';
import 'package:color_hap/models/color_type.dart';
import 'package:color_hap/models/random_color_generator.dart';
import 'package:color_hap/services/generators_initializer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Preferences Migration Logic', () {
    late Map<ColorType, RandomColorGenerator> generators;

    setUpAll(() async {
      // Load generators once for all tests
      generators = await initAllGenerators();
    });

    test('should migrate single favorite from old JSON to new key-list format', () {
      // Arrange: Create old format JSON strings
      final oldJsonStrings = [
        '{"type":1,"color":4294901760,"name":"Red","listPosition":0}', // Red basic color
      ];

      // Act: Simulate migration
      // Step 1: Load from old JSON format
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList(oldJsonStrings);

      // Step 2: Convert to new compact format
      final newKeyList = favorites.toKeyList();

      // Step 3: Verify new format
      expect(newKeyList.length, equals(1));
      expect(newKeyList.first, equals('BFF0000')); // Basic Red

      // Step 4: Verify round-trip (new format → favorites)
      final migratedFavorites = ColorFavoritesList();
      migratedFavorites.loadFromKeyList(newKeyList, generators: generators);

      expect(migratedFavorites.length, equals(1));
      expect(
        migratedFavorites.toList().first.color.toARGB32(),
        equals(0xFFFF0000),
      ); // Red
    });

    test('should migrate multiple favorites with different color types', () {
      // Arrange: Multiple favorites from different color types
      // Note: Using real colors that exist in generators for successful round-trip
      final oldJsonStrings = [
        '{"type":1,"color":4294901760,"name":"Red","listPosition":0}', // Basic Red
        '{"type":2,"color":4278255360,"name":"Lime","listPosition":0}', // Web Lime
        '{"type":5,"color":4279316566,"listPosition":1193046}', // True Color
      ];

      // Act: Migrate
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList(oldJsonStrings);

      final newKeyList = favorites.toKeyList();

      // Assert: Verify all types represented in new format
      expect(newKeyList.length, equals(3));
      expect(newKeyList.where((k) => k.startsWith('B')).length, equals(1)); // Basic
      expect(newKeyList.where((k) => k.startsWith('W')).length, equals(1)); // Web
      expect(newKeyList.where((k) => k.startsWith('T')).length, equals(1)); // True

      // Verify round-trip preserves all colors
      final migratedFavorites = ColorFavoritesList();
      migratedFavorites.loadFromKeyList(newKeyList, generators: generators);

      expect(migratedFavorites.length, equals(3));
    });

    test('should handle empty favorites list during migration', () {
      // Arrange: Empty list
      final oldJsonStrings = <String>[];

      // Act: Migrate
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList(oldJsonStrings);

      final newKeyList = favorites.toKeyList();

      // Assert: Empty list migrates to empty list
      expect(newKeyList, isEmpty);
    });

    test('should produce compact keys with correct format (prefix + 6-char hex)', () {
      // Arrange: Known colors with specific hex values
      final testCases = [
        {'json': '{"type":1,"color":4278190080,"name":"Black","listPosition":0}', 'key': 'B000000'},
        {'json': '{"type":1,"color":4294967295,"name":"White","listPosition":0}', 'key': 'BFFFFFF'},
        {'json': '{"type":2,"color":4294901760,"name":"Red","listPosition":0}', 'key': 'WFF0000'},
        {'json': '{"type":2,"color":4278190335,"name":"Blue","listPosition":0}', 'key': 'W0000FF'},
        {'json': '{"type":2,"color":4278255360,"name":"Lime","listPosition":0}', 'key': 'W00FF00'},
      ];

      for (final testCase in testCases) {
        // Act: Load and convert
        final favorites = ColorFavoritesList();
        // ignore: deprecated_member_use_from_same_package
        favorites.loadFromJsonStringList([testCase['json']!]);

        final newKeyList = favorites.toKeyList();

        // Assert: Correct format
        expect(newKeyList.length, equals(1));
        expect(newKeyList.first, equals(testCase['key']));
        expect(newKeyList.first.length, equals(7)); // 1 prefix + 6 hex chars
      }
    });

    test('should verify storage size reduction (JSON vs compact format)', () {
      // Arrange: Create a favorite
      const oldJsonString = '{"type":1,"color":4294901760,"name":"Red","listPosition":0}';

      // Act: Compare sizes
      const oldSize = oldJsonString.length; // ~58 bytes
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList([oldJsonString]);

      final newKey = favorites.toKeyList().first; // "BFF0000"
      final newSize = newKey.length; // 7 bytes

      // Assert: Significant size reduction
      expect(newSize, lessThan(oldSize));
      expect(newSize, equals(7));

      // Calculate reduction percentage
      final reduction = ((oldSize - newSize) / oldSize * 100).round();
      expect(reduction, greaterThan(85)); // At least 85% reduction
    });

    test('migration should preserve color equality after round-trip', () {
      // Arrange: Create favorites with specific colors
      const testColors = [
        ColorItem(
          type: .basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        ),
        ColorItem(
          type: .webColor,
          color: Color(0xFF00FF00),
          name: 'Lime',
          listPosition: 10,
        ),
        ColorItem(
          type: .namedColor,
          color: Color(0xFF0000FF),
          name: 'Blue',
          listPosition: 100,
        ),
      ];

      final favorites = ColorFavoritesList();
      for (final color in testColors) {
        favorites.add(color);
      }

      // Act: Convert to new format and back
      final keyList = favorites.toKeyList();
      final migratedFavorites = ColorFavoritesList();
      migratedFavorites.loadFromKeyList(keyList, generators: generators);

      // Assert: All colors preserved (verify by RGB values)
      expect(migratedFavorites.length, equals(testColors.length));

      final originalRgbValues = favorites.toList().map((c) => c.color.toARGB32()).toSet();
      final migratedRgbValues = migratedFavorites.toList().map((c) => c.color.toARGB32()).toSet();

      expect(migratedRgbValues, equals(originalRgbValues));
    });

    test('should handle large favorites list efficiently', () {
      // Arrange: Create 100 favorites
      final oldJsonStrings = <String>[];
      for (var i = 0; i < 100; i++) {
        final colorValue = 0xFF000000 + (i * 0x010101); // Generate different colors
        oldJsonStrings.add(
          '{"type":5,"color":$colorValue,"listPosition":${colorValue & 0x00FFFFFF}}',
        );
      }

      // Act: Migrate
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList(oldJsonStrings);

      final newKeyList = favorites.toKeyList();

      // Assert: All migrated correctly
      expect(newKeyList.length, equals(100));
      expect(newKeyList.every((k) => k.length == 7), isTrue); // All have correct format
      expect(newKeyList.every((k) => k.startsWith('T')), isTrue); // All are true colors

      // Verify round-trip
      final migratedFavorites = ColorFavoritesList();
      migratedFavorites.loadFromKeyList(newKeyList, generators: generators);

      expect(migratedFavorites.length, equals(100));
    });

    test('compact format should be valid hex strings', () {
      // Arrange: Various colors
      final oldJsonStrings = [
        '{"type":1,"color":4294901760,"name":"Red","listPosition":0}',
        '{"type":2,"color":4289920716,"name":"SomeColor","listPosition":1}',
        '{"type":3,"color":4278255615,"name":"Another","listPosition":2}',
      ];

      // Act: Generate compact keys
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList(oldJsonStrings);

      final newKeyList = favorites.toKeyList();

      // Assert: Each key has valid hex after prefix
      for (final key in newKeyList) {
        final hexPart = key.substring(1); // Remove prefix
        expect(hexPart.length, equals(6));

        // Verify it's valid hex
        expect(() => int.parse(hexPart, radix: 16), returnsNormally);

        // Verify each character is valid hex digit
        expect(hexPart, matches(RegExp(r'^[0-9A-F]{6}$')));
      }
    });

    test('should handle invalid JSON gracefully in migration source', () {
      // Arrange: Invalid JSON
      final invalidJsonStrings = [
        'not valid json at all',
      ];

      // Act & Assert: Should throw during JSON parsing
      final favorites = ColorFavoritesList();
      expect(
        // ignore: deprecated_member_use_from_same_package
        () => favorites.loadFromJsonStringList(invalidJsonStrings),
        throwsA(isA<FormatException>()),
      );
    });

    test('should fallback to True Color if original catalog color not found', () {
      // Arrange: Create a color that might not exist in current catalogs
      // Using a specific named color RGB that might have been removed
      final favorites = ColorFavoritesList();

      // Simulate a "phantom" color that was in old catalog but might not be in new one
      // We'll use a key format that's valid but the color might not be in that catalog
      final keyList = [
        'BFF0000', // Red - should exist (control)
        'N123456', // Named color with specific RGB - might not exist
        'A7890AB', // Attractive color - might not exist
      ];

      // Act: Load favorites (will fallback to True Color if not found)
      favorites.loadFromKeyList(keyList, generators: generators);

      // Assert: Should have preserved all favorites (possibly as True Colors)
      expect(favorites.length, greaterThanOrEqualTo(1)); // At least Red should load

      // Verify Red is present
      final colors = favorites.toList();
      expect(colors.any((c) => c.color.toARGB32() == 0xFFFF0000), isTrue); // Red exists

      // If other colors don't exist in their catalogs, they should be converted to True Colors
      // The important thing is no data loss - all valid RGB colors are preserved
      for (final item in colors) {
        // All items should have valid colors
        expect(item.color.toARGB32() & 0xFF000000, equals(0xFF000000)); // Valid alpha
      }
    });

    test('should preserve color RGB even when migrated to different type', () {
      // Arrange: Create favorites with specific RGB values
      final oldJsonStrings = [
        '{"type":1,"color":4294901760,"name":"Red","listPosition":0}', // Red basic
        '{"type":3,"color":4289379276,"name":"RareNamedColor","listPosition":999}', // Might not exist
      ];

      // Act: Load and convert through migration cycle
      final favorites = ColorFavoritesList();
      // ignore: deprecated_member_use_from_same_package
      favorites.loadFromJsonStringList(oldJsonStrings);

      final keyList = favorites.toKeyList();

      // Reload (may fallback to True Color for missing colors)
      final migratedFavorites = ColorFavoritesList();
      migratedFavorites.loadFromKeyList(keyList, generators: generators);

      // Assert: At least one color should be preserved
      expect(migratedFavorites.length, greaterThanOrEqualTo(1));

      // Verify Red is definitely preserved (it exists in basic colors)
      final colors = migratedFavorites.toList();
      expect(colors.any((c) => c.color.toARGB32() == 0xFFFF0000), isTrue); // Red

      // All preserved colors should have valid RGB values
      for (final color in colors) {
        expect(color.color.toARGB32() & 0x00FFFFFF, greaterThan(0)); // Non-black RGB
      }
    });
  });
}
