// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';

/// Service for looking up colors in the known color catalogs.
///
/// This service maintains a map of all known colors (basic, web, named, and attractive)
/// for fast O(1) lookup. The map is initialized once at app startup and provides a way
/// to determine if a given color exists in any of the catalogs, along with its proper
/// type and name (if available).
///
/// The lookup follows a priority order when colors appear in multiple catalogs:
/// Basic > Web > Named > Attractive

/// The internal lookup map containing all known colors.
/// Key: 24-bit RGB color code (without alpha channel)
/// Value: ColorItem with proper type, name, and list position
final Map<int, ColorItem> _knownColorsMap = {};

/// Initializes the color lookup service with all known colors from the generators.
///
/// This should be called once during app initialization, after all color generators
/// have been loaded. The map is populated in reverse priority order (attractive first,
/// basic last) so that higher priority colors overwrite lower priority ones.
///
/// Memory footprint: ~562 KB for 11,719 colors
void initColorLookup(Map<ColorType, RandomColorGenerator> generators) {
  _knownColorsMap.clear();

  // Add colors in reverse priority order (later additions overwrite earlier ones)
  // Priority: Basic > Web > Named > Attractive
  _addColorsToMap(generators[ColorType.attractiveColor]!); // Lowest priority (10,000 colors)
  _addColorsToMap(generators[ColorType.namedColor]!); // Medium priority (1,566 colors)
  _addColorsToMap(generators[ColorType.webColor]!); // High priority (139 colors)
  _addColorsToMap(generators[ColorType.basicColor]!); // Highest priority (14 colors)
}

/// Adds all colors from a generator to the lookup map.
void _addColorsToMap(RandomColorGenerator generator) {
  for (var i = 0; i < generator.length; i++) {
    final item = generator.elementAt(i);
    // Use 24-bit RGB as key (strip alpha channel for consistency)
    final rgb24 = item.color.toARGB32() & 0x00FFFFFF;
    _knownColorsMap[rgb24] = item;
  }
}

/// Looks up a color in the known colors catalog.
///
/// Returns the [ColorItem] with the proper color type and name if the color
/// exists in any of the catalogs (basic, web, named, or attractive).
/// Returns null if the color is not found in any catalog.
///
/// The returned [ColorItem] will have the highest priority type if the color
/// exists in multiple catalogs (e.g., #FF0000 exists in both basic and web,
/// but will be returned as a basic color).
///
/// This is an O(1) operation with typical lookup time of 50-120 nanoseconds.
ColorItem? findKnownColor(Color color) {
  final rgb24 = color.toARGB32() & 0x00FFFFFF;
  return _knownColorsMap[rgb24];
}

/// Returns the number of colors in the lookup map.
///
/// This is primarily useful for debugging and testing to verify that all
/// colors have been loaded correctly.
int get knownColorsCount => _knownColorsMap.length;
