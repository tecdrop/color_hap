// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Loads all named color lists from bundled JSON assets.
library;

import 'dart:convert' as convert;
import 'package:flutter/foundation.dart' show kDebugMode;
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
import 'color_lookup_service.dart' as color_lookup;

Future<Map<ColorType, RandomColorGenerator>> initAllGenerators() async {
  // Map of color data files for each ColorType
  final colorDataFiles = <ColorType, String>{
    .basicColor: 'data/colors/basic_colors.json',
    .webColor: 'data/colors/web_colors.json',
    .namedColor: 'data/colors/named_colors.json',
    .attractiveColor: 'data/colors/attractive_colors.json',
  };

  // Map to hold the initialized generators
  final generators = <ColorType, RandomColorGenerator>{};

  // Load and parse each color data file
  for (final type in colorDataFiles.keys) {
    final colorItems = await _loadColorItems(type, colorDataFiles[type]!);

    // Create the appropriate generator based on the ColorType
    final generator = switch (type) {
      ColorType.basicColor => RandomBasicColorGenerator(colorItems),
      ColorType.webColor => RandomWebColorGenerator(colorItems),
      ColorType.namedColor => RandomNamedColorGenerator(colorItems),
      ColorType.attractiveColor => RandomAttractiveColorGenerator(colorItems),
      _ => null,
    };

    if (generator != null) {
      generators[type] = generator;
    }
  }

  // Create the true color generator
  generators[.trueColor] = RandomTrueColorGenerator();

  // Create the mixed color generator, which depends on other generators
  generators[.mixedColor] = RandomMixedColorGenerator(generators);

  // Initialize the color lookup service with all known colors
  color_lookup.initColorLookup(generators);

  return generators;
}

/// Loads color items from a JSON data file for the given [ColorType].
Future<List<ColorItem>> _loadColorItems(ColorType type, String colorDataFile) async {
  final colorItems = <ColorItem>[];

  // Load each color data file as a string
  final colorDataString = await rootBundle.loadString(colorDataFile);

  // Decode the JSON string
  final decodedColorData = convert.jsonDecode(colorDataString);

  // A valid color data file must be a JSON array; skip invalid files, just log in debug mode
  if (decodedColorData is! List) {
    if (kDebugMode) debugPrint('Invalid color data file for ${type.id}: Not a JSON array');
    return colorItems;
  }

  // Parse each color item from the JSON array
  for (var i = 0; i < decodedColorData.length; i++) {
    final item = decodedColorData[i];

    try {
      final colorItem = ColorItem.fromCompactJson(item, type, colorItems.length);
      colorItems.add(colorItem);
    } on Exception catch (e) {
      // Skip invalid entries, just log in debug mode
      if (kDebugMode) debugPrint('Failed to parse color item in ${type.id} at index $i: $e');
    }
  }

  return colorItems;
}
