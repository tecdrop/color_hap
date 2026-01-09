// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:color_hap/models/color_favorites_list.dart';
import 'package:color_hap/models/color_item.dart';
import 'package:color_hap/models/color_type.dart';
import 'package:color_hap/models/random_color_generator.dart';
import 'package:color_hap/services/generators_initializer.dart';

void main() {
  group('ColorFavoritesList', () {
    late ColorFavoritesList favoritesList;
    late Map<ColorType, RandomColorGenerator> generators;

    // Test color items
    const redColor = ColorItem(
      type: .basicColor,
      color: Color(0xFFFF0000),
      name: 'Red',
      listPosition: 0,
    );

    const blueColor = ColorItem(
      type: .basicColor,
      color: Color(0xFF0000FF),
      name: 'Blue',
      listPosition: 1,
    );

    const greenColor = ColorItem(
      type: .webColor,
      color: Color(0xFF00FF00),
      name: 'Lime',
      listPosition: 0,
    );

    setUpAll(() async {
      // Load generators once for all tests
      TestWidgetsFlutterBinding.ensureInitialized();
      generators = await initAllGenerators();
    });

    setUp(() {
      // Create fresh instance for each test
      favoritesList = ColorFavoritesList();
    });

    group('Basic Operations', () {
      test('should start empty', () {
        expect(favoritesList.length, equals(0));
      });

      test('add should add color and return true', () {
        final result = favoritesList.add(redColor);

        expect(result, isTrue);
        expect(favoritesList.length, equals(1));
        expect(favoritesList.contains(redColor), isTrue);
      });

      test('add should not add duplicate and return false', () {
        favoritesList.add(redColor);
        final result = favoritesList.add(redColor);

        expect(result, isFalse);
        expect(favoritesList.length, equals(1));
      });

      test('remove should remove existing color and return true', () {
        favoritesList.add(redColor);
        final result = favoritesList.remove(redColor);

        expect(result, isTrue);
        expect(favoritesList.length, equals(0));
        expect(favoritesList.contains(redColor), isFalse);
      });

      test('remove should return false for non-existent color', () {
        final result = favoritesList.remove(redColor);

        expect(result, isFalse);
        expect(favoritesList.length, equals(0));
      });

      test('contains should return true for existing color', () {
        favoritesList.add(redColor);

        expect(favoritesList.contains(redColor), isTrue);
        expect(favoritesList.contains(blueColor), isFalse);
      });

      test('clear should remove all colors', () {
        favoritesList.add(redColor);
        favoritesList.add(blueColor);
        favoritesList.add(greenColor);

        favoritesList.clear();

        expect(favoritesList.length, equals(0));
      });
    });

    group('Toggle Operation', () {
      test('toggle should add new color and return ToggleResult.added', () {
        final result = favoritesList.toggle(redColor);

        expect(result, equals(ToggleResult.added));
        expect(favoritesList.contains(redColor), isTrue);
        expect(favoritesList.length, equals(1));
      });

      test('toggle should remove existing color and return ToggleResult.removed', () {
        favoritesList.add(redColor);
        final result = favoritesList.toggle(redColor);

        expect(result, equals(ToggleResult.removed));
        expect(favoritesList.contains(redColor), isFalse);
        expect(favoritesList.length, equals(0));
      });

      test('toggle should alternate between add and remove', () {
        // First toggle: add
        var result = favoritesList.toggle(redColor);
        expect(result, equals(ToggleResult.added));
        expect(favoritesList.length, equals(1));

        // Second toggle: remove
        result = favoritesList.toggle(redColor);
        expect(result, equals(ToggleResult.removed));
        expect(favoritesList.length, equals(0));

        // Third toggle: add again
        result = favoritesList.toggle(redColor);
        expect(result, equals(ToggleResult.added));
        expect(favoritesList.length, equals(1));
      });
    });

    group('Callback Mechanism', () {
      test('onChanged should be called when color is added', () {
        var callbackInvoked = false;
        favoritesList = ColorFavoritesList(
          onChanged: () => callbackInvoked = true,
        );

        favoritesList.add(redColor);

        expect(callbackInvoked, isTrue);
      });

      test('onChanged should be called when color is removed', () {
        favoritesList = ColorFavoritesList(
          onChanged: () {}, // no-op for setup
        );
        favoritesList.add(redColor);

        var callbackInvoked = false;
        favoritesList = ColorFavoritesList(
          onChanged: () => callbackInvoked = true,
        );
        favoritesList.add(redColor); // Re-add to new instance

        favoritesList.remove(redColor);

        expect(callbackInvoked, isTrue);
      });

      test('onChanged should be called when toggling', () {
        var callbackCount = 0;
        favoritesList = ColorFavoritesList(
          onChanged: () => callbackCount++,
        );

        favoritesList.toggle(redColor); // Add
        expect(callbackCount, equals(1));

        favoritesList.toggle(redColor); // Remove
        expect(callbackCount, equals(2));
      });

      test('onChanged should be called when clearing', () {
        var callbackInvoked = false;
        favoritesList = ColorFavoritesList(
          onChanged: () => callbackInvoked = true,
        );
        favoritesList.add(redColor);
        favoritesList.add(blueColor);

        callbackInvoked = false; // Reset after adds
        favoritesList.clear();

        expect(callbackInvoked, isTrue);
      });

      test('should not crash when onChanged is null', () {
        favoritesList = ColorFavoritesList(); // No callback

        expect(() => favoritesList.add(redColor), returnsNormally);
        expect(() => favoritesList.remove(redColor), returnsNormally);
        expect(() => favoritesList.toggle(blueColor), returnsNormally);
        expect(() => favoritesList.clear(), returnsNormally);
      });
    });

    group('Compact Storage Format', () {
      test('toKeyList should produce correct compact format', () {
        favoritesList.add(redColor);
        favoritesList.add(blueColor);
        favoritesList.add(greenColor);

        final keyList = favoritesList.toKeyList();

        expect(keyList.length, equals(3));
        expect(keyList, contains('BFF0000')); // Basic Red
        expect(keyList, contains('B0000FF')); // Basic Blue
        expect(keyList, contains('W00FF00')); // Web Lime
      });

      test('toKeyList should return empty list when no favorites', () {
        final keyList = favoritesList.toKeyList();

        expect(keyList.length, equals(0));
      });

      test('toKeyList should handle colors from different types', () {
        const basicColor = ColorItem(
          type: .basicColor,
          color: Color(0xFF000000),
          name: 'Black',
          listPosition: 0,
        );
        const webColor = ColorItem(
          type: .webColor,
          color: Color(0xFFFFFFFF),
          name: 'White',
          listPosition: 0,
        );
        const namedColor = ColorItem(
          type: .namedColor,
          color: Color(0xFF888888),
          name: 'Gray',
          listPosition: 0,
        );
        const attractiveColor = ColorItem(
          type: .attractiveColor,
          color: Color(0xFFAABBCC),
          listPosition: 100,
        );
        const trueColor = ColorItem(
          type: .trueColor,
          color: Color(0xFF123456),
          listPosition: 0x123456,
        );

        favoritesList.add(basicColor);
        favoritesList.add(webColor);
        favoritesList.add(namedColor);
        favoritesList.add(attractiveColor);
        favoritesList.add(trueColor);

        final keyList = favoritesList.toKeyList();

        expect(keyList, contains('B000000')); // Basic Black
        expect(keyList, contains('WFFFFFF')); // Web White
        expect(keyList, contains('N888888')); // Named Gray
        expect(keyList, contains('AAABBCC')); // Attractive
        expect(keyList, contains('T123456')); // True Color
      });
    });

    group('Compact JSON Parsing', () {
      test('fromCompactJson should parse short and long hex and accept leading #', () {
        final ci1 = ColorItem.fromCompactJson(['#FFF'], ColorType.trueColor, 0);
        expect(ci1.color.toARGB32() & 0xFFFFFF, equals(0xFFFFFF));

        final ci2 = ColorItem.fromCompactJson(['fff'], ColorType.trueColor, 1);
        expect(ci2.color.toARGB32() & 0xFFFFFF, equals(0xFFFFFF));

        final ci3 = ColorItem.fromCompactJson(['FCF5AB'], ColorType.trueColor, 2);
        expect(ci3.color.toARGB32() & 0xFFFFFF, equals(0xFCF5AB));
      });

      test('fromCompactJson should throw on invalid hex input', () {
        expect(
          () => ColorItem.fromCompactJson(['GGG'], ColorType.basicColor, 0),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Load from Key List', () {
      test('loadFromKeyList should reconstruct favorites correctly', () {
        final keyList = ['BFF0000', 'B0000FF', 'W00FF00'];

        favoritesList.loadFromKeyList(keyList, generators: generators);

        expect(favoritesList.length, equals(3));

        // Verify colors were reconstructed correctly
        final favoriteColors = favoritesList.toList();
        expect(favoriteColors.any((c) => c.color.toARGB32() == 0xFFFF0000), isTrue); // Red
        expect(favoriteColors.any((c) => c.color.toARGB32() == 0xFF0000FF), isTrue); // Blue
        expect(favoriteColors.any((c) => c.color.toARGB32() == 0xFF00FF00), isTrue); // Lime
      });

      test('loadFromKeyList should handle empty list', () {
        favoritesList.add(redColor);

        favoritesList.loadFromKeyList([], generators: generators);

        expect(favoritesList.length, equals(0));
      });

      test('loadFromKeyList should handle null list', () {
        favoritesList.add(redColor);

        favoritesList.loadFromKeyList(null, generators: generators);

        expect(favoritesList.length, equals(1)); // Should not clear
      });

      test('loadFromKeyList should skip invalid keys gracefully', () {
        final keyList = [
          'BFF0000', // Valid: Red
          'XINVALID', // Invalid prefix
          'B0000FF', // Valid: Blue
          'ZZZZZZZ', // Invalid prefix
        ];

        favoritesList.loadFromKeyList(keyList, generators: generators);

        // Should only load the 2 valid colors
        expect(favoritesList.length, equals(2));
      });

      test('loadFromKeyList should skip entries with invalid hex gracefully', () {
        final keyList = [
          'BFF0000', // valid red
          'BZZZZZZ', // invalid hex, valid prefix
          'B0000FF', // valid blue
          'W#GGG', // invalid hex with hash, valid prefix
        ];

        favoritesList.loadFromKeyList(keyList, generators: generators);

        // Should only load the 2 valid colors
        expect(favoritesList.length, equals(2));
      });

      test('loadFromKeyList should clear existing favorites first', () {
        favoritesList.add(redColor);
        favoritesList.add(blueColor);

        final keyList = ['W00FF00']; // Only green

        favoritesList.loadFromKeyList(keyList, generators: generators);

        expect(favoritesList.length, equals(1));
        expect(favoritesList.toList().first.color.toARGB32(), equals(0xFF00FF00));
      });

      test('loadFromKeyList should not call onChanged callback', () {
        var callbackCount = 0;
        favoritesList = ColorFavoritesList(
          onChanged: () => callbackCount++,
        );

        final keyList = ['BFF0000', 'B0000FF'];
        favoritesList.loadFromKeyList(keyList, generators: generators);

        // Loading from storage should NOT trigger onChanged
        expect(callbackCount, equals(0));
      });
    });

    group('Deprecated JSON Loading (Migration)', () {
      test('loadFromJsonStringList should reconstruct favorites from old format', () {
        final jsonList = [
          '{"type":1,"color":4294901760,"name":"Red","listPosition":0}',
          '{"type":1,"color":4278190335,"name":"Blue","listPosition":1}',
        ];

        // ignore: deprecated_member_use_from_same_package
        favoritesList.loadFromJsonStringList(jsonList);

        expect(favoritesList.length, equals(2));

        final favoriteColors = favoritesList.toList();
        expect(favoriteColors.any((c) => c.name == 'Red'), isTrue);
        expect(favoriteColors.any((c) => c.name == 'Blue'), isTrue);
      });

      test('loadFromJsonStringList should handle empty list', () {
        favoritesList.add(redColor);

        // ignore: deprecated_member_use_from_same_package
        favoritesList.loadFromJsonStringList([]);

        expect(favoritesList.length, equals(0));
      });

      test('loadFromJsonStringList should handle null list', () {
        favoritesList.add(redColor);

        // ignore: deprecated_member_use_from_same_package
        favoritesList.loadFromJsonStringList(null);

        expect(favoritesList.length, equals(1)); // Should not clear
      });

      test('loadFromJsonStringList should not call onChanged callback', () {
        var callbackCount = 0;
        favoritesList = ColorFavoritesList(
          onChanged: () => callbackCount++,
        );

        final jsonList = [
          '{"type":1,"color":4294901760,"name":"Red","listPosition":0}',
        ];

        // ignore: deprecated_member_use_from_same_package
        favoritesList.loadFromJsonStringList(jsonList);

        // Migration loading should NOT trigger onChanged
        expect(callbackCount, equals(0));
      });
    });

    group('Round-Trip Persistence', () {
      test('should preserve favorites through save/load cycle', () {
        // Add some favorites
        favoritesList.add(redColor);
        favoritesList.add(blueColor);
        favoritesList.add(greenColor);

        // Save to key list
        final keyList = favoritesList.toKeyList();

        // Create new instance and load
        final newFavorites = ColorFavoritesList();
        newFavorites.loadFromKeyList(keyList, generators: generators);

        // Verify same favorites exist
        expect(newFavorites.length, equals(3));
        expect(
          newFavorites.toList().map((c) => c.color.toARGB32()).toSet(),
          equals(
            favoritesList.toList().map((c) => c.color.toARGB32()).toSet(),
          ),
        );
      });
    });

    group('Collection Methods', () {
      test('toList should return all favorites as list', () {
        favoritesList.add(redColor);
        favoritesList.add(blueColor);

        final list = favoritesList.toList();

        expect(list, isA<List<ColorItem>>());
        expect(list.length, equals(2));
        expect(list.contains(redColor), isTrue);
        expect(list.contains(blueColor), isTrue);
      });

      test('toList should return empty list when no favorites', () {
        final list = favoritesList.toList();

        expect(list.length, equals(0));
      });
    });

    group('Edge Cases', () {
      test('should handle adding many colors', () {
        // Add 100 colors
        for (var i = 0; i < 100; i++) {
          final color = ColorItem(
            type: .trueColor,
            color: Color(0xFF000000 + i),
            listPosition: i,
          );
          favoritesList.add(color);
        }

        expect(favoritesList.length, equals(100));
      });

      test('should maintain set properties (no duplicates)', () {
        // Try adding same color multiple times
        for (var i = 0; i < 10; i++) {
          favoritesList.add(redColor);
        }

        expect(favoritesList.length, equals(1));
      });

      test('should handle colors with same RGB but different types', () {
        const color1 = ColorItem(
          type: .basicColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );

        const color2 = ColorItem(
          type: .webColor,
          color: Color(0xFFFF0000),
          name: 'Red',
          listPosition: 0,
        );

        favoritesList.add(color1);
        favoritesList.add(color2);

        // Should treat as different colors because ColorItem equality
        // considers the entire object, not just the color value
        expect(favoritesList.length, equals(2));
      });
    });
  });
}
