// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Loads all named color lists from bundled JSON assets.
library;

import 'dart:convert' as convert;
import 'package:flutter/foundation.dart' show compute, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../generators/random_attractive_color_generator.dart';
import '../generators/random_basic_color_generator.dart';
import '../generators/random_mixed_color_generator.dart';
import '../generators/random_named_color_generator.dart';
import '../generators/random_true_color_generator.dart';
import '../generators/random_web_color_generator.dart';
import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../utils/color_utils.dart' as color_utils;
import 'color_lookup_service.dart' as color_lookup;

Future<Map<ColorType, RandomColorGenerator>> initAllGenerators() async {
  final catalogPaths = <ColorType, String>{
    .basicColor: 'data/colors/basic_colors.json',
    .webColor: 'data/colors/web_colors.json',
    .namedColor: 'data/colors/named_colors.json',
    .attractiveColor: 'data/colors/attractive_colors.json',
  };

  final colorLists = await _loadAllColorLists(catalogPaths);

  final generators = <ColorType, RandomColorGenerator>{
    .basicColor: RandomBasicColorGenerator(colorLists[ColorType.basicColor] ?? []),
    .webColor: RandomWebColorGenerator(colorLists[ColorType.webColor] ?? []),
    .namedColor: RandomNamedColorGenerator(colorLists[ColorType.namedColor] ?? []),
    .attractiveColor: RandomAttractiveColorGenerator(
      colorLists[ColorType.attractiveColor] ?? [],
    ),
    .trueColor: RandomTrueColorGenerator(),
  };
  generators[.mixedColor] = RandomMixedColorGenerator(generators);

  // Initialize the color lookup service with all known colors
  color_lookup.initColorLookup(generators);

  return generators;
}

Future<Map<ColorType, List<ColorItem>>> _loadAllColorLists(
  Map<ColorType, String> catalogPaths,
) async {
  // Phase 1: Asynchronously load all named color lists from assets as strings
  // Use string keys (enum id) for safe isolate communication
  final jsonData = <String, String>{};
  for (final entry in catalogPaths.entries) {
    jsonData[entry.key.id] = await rootBundle.loadString(entry.value);
  }

  // Phase 2: Parse all named color lists in the background in a single isolate
  final parsedData = await compute(_parseAllColorLists, jsonData);

  // Phase 3: Convert string keys (id) back to enum keys
  final result = <ColorType, List<ColorItem>>{};
  for (final entry in parsedData.entries) {
    final colorType = ColorType.values.firstWhere((type) => type.id == entry.key);
    result[colorType] = entry.value;
  }
  return result;
}

// Top-level function for compute
// Uses string keys (enum id) for safe isolate communication
Map<String, List<ColorItem>> _parseAllColorLists(Map<String, String> jsonData) {
  final result = <String, List<ColorItem>>{};

  // Parse all JSON data files received as strings from the main isolate
  for (final entry in jsonData.entries) {
    final colorTypeId = entry.key;
    final jsonString = entry.value;

    try {
      // Reconstruct the ColorType enum from the string id
      final colorType = ColorType.values.firstWhere((type) => type.id == colorTypeId);

      // Decode the JSON string
      final dynamic decoded = convert.jsonDecode(jsonString);
      if (decoded is! List) continue; // Skip invalid files

      final colors = <ColorItem>[];

      // Parse all color entries from the JSON array
      for (final dynamic item in decoded) {
        if (item is! Map) continue; // skip invalid entries
        final rawCode = (item['code'] as String?)?.trim();
        final name = (item['name'] as String?)?.trim();
        if (rawCode == null || rawCode.isEmpty) {
          continue; // skip invalid entries
        }

        // Convert the hex color code string to a Color object
        final color = color_utils.rgbHexToColor(rawCode);
        if (color == null) continue; // skip invalid entries

        // Add the new RandomColor object to the list
        colors.add(
          ColorItem(type: colorType, color: color, name: name, listPosition: colors.length),
        );
      }

      // Add the successfully parsed color list to the result (with string id key)
      result[colorTypeId] = colors;
    } on Exception catch (e) {
      // Skip failed catalogs, just log in debug mode
      if (kDebugMode) debugPrint('Failed to parse catalog for $colorTypeId: $e');
    }
  }

  return result;
}
