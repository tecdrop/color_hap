// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Loads all named color lists from bundled JSON assets.
library;

import 'dart:convert' as convert;

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../generators/random_attractive_color_generator.dart';
import '../generators/random_basic_color_generator.dart';
import '../generators/random_mixed_color_generator.dart';
import '../generators/random_named_color_generator.dart';
import '../generators/random_true_color_generator.dart';
import '../generators/random_web_color_generator.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../models/color_item.dart';
import '../utils/color_utils.dart' as color_utils;

Future<Map<ColorType, RandomColorGenerator>> initAllGenerators() async {
  final catalogPaths = {
    ColorType.basicColor: 'data/colors/basic_colors.json',
    ColorType.webColor: 'data/colors/web_colors.json',
    ColorType.namedColor: 'data/colors/named_colors.json',
    ColorType.attractiveColor: 'data/colors/attractive_colors.json',
  };

  final Map<ColorType, List<ColorItem>> colorLists = await _loadAllColorLists(catalogPaths);

  final generators = <ColorType, RandomColorGenerator>{
    ColorType.basicColor: RandomBasicColorGenerator(colorLists[ColorType.basicColor] ?? []),
    ColorType.webColor: RandomWebColorGenerator(colorLists[ColorType.webColor] ?? []),
    ColorType.namedColor: RandomNamedColorGenerator(colorLists[ColorType.namedColor] ?? []),
    ColorType.attractiveColor: RandomAttractiveColorGenerator(
      colorLists[ColorType.attractiveColor] ?? [],
    ),

    ColorType.trueColor: RandomTrueColorGenerator(),
    ColorType.mixedColor: RandomTrueColorGenerator(),
  };
  generators[ColorType.mixedColor] = RandomMixedColorGenerator(generators);
  return generators;
}

Future<Map<ColorType, List<ColorItem>>> _loadAllColorLists(
  Map<ColorType, String> catalogPaths,
) async {
  // Phase 1: Asynchronously load all named color lists from assets as strings
  final Map<ColorType, String> jsonData = {};
  for (final MapEntry<ColorType, String> entry in catalogPaths.entries) {
    jsonData[entry.key] = await rootBundle.loadString(entry.value);
  }

  // Phase 2: Parse all named color lists in the background in a single isolate
  return await compute(_parseAllColorLists, jsonData);
}

// Top-level function for compute
Map<ColorType, List<ColorItem>> _parseAllColorLists(Map<ColorType, String> jsonData) {
  final Map<ColorType, List<ColorItem>> result = {};

  // Parse all JSON data files received as strings from the main isolate
  for (final MapEntry<ColorType, String> entry in jsonData.entries) {
    final ColorType colorType = entry.key;
    final String jsonString = entry.value;

    try {
      // Decode the JSON string
      final dynamic decoded = convert.jsonDecode(jsonString);
      if (decoded is! List) continue; // Skip invalid files

      final List<ColorItem> colors = [];

      // Parse all color entries from the JSON array
      for (final dynamic item in decoded) {
        if (item is! Map) continue; // skip invalid entries
        final String? rawCode = (item['code'] as String?)?.trim();
        final String? name = (item['name'] as String?)?.trim();
        // if (rawCode == null || rawCode.isEmpty || name == null || name.isEmpty) {
        if (rawCode == null || rawCode.isEmpty) {
          continue; // skip invalid entries
        }

        // Convert the hex color code string to a Color object
        final Color? color = color_utils.rgbHexToColor(rawCode);
        if (color == null) continue; // skip invalid entries

        // Add the new RandomColor object to the list
        colors.add(
          ColorItem(type: colorType, color: color, name: name, listPosition: colors.length),
        );
      }

      // Add the successfully parsed color list to the result
      result[colorType] = colors;
    } catch (e) {
      // Skip failed catalogs, log if needed
      debugPrint('Failed to parse catalog for $colorType: $e');
    }
  }

  return result;
}
