// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'dart:ui';

import '../../utils/color_utils.dart' as color_utils;
import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../services/color_lookup_service.dart' as color_lookup;

/// A random color generator that generates random true colors (24-bit colors).
class RandomTrueColorGenerator implements RandomColorGenerator {
  @override
  ColorType get colorType => .trueColor;

  /// Generates a random true color.
  ///
  /// If the generated color exists in the known color catalogs (basic, web, named, or
  /// attractive), returns a ColorItem with the proper type and name. Otherwise, returns
  /// a true color ColorItem.
  @override
  ColorItem next(Random random) {
    // Generate a random 24-bit color code, which is a number between 0x000000 and 0xFFFFFF
    final randomColorCode = random.nextInt(0xFFFFFF + 1);
    final color = Color(color_utils.withFullAlpha(randomColorCode));

    // Check if this color exists in any known catalog
    final knownColor = color_lookup.findKnownColor(color);
    if (knownColor != null) {
      // Return the known color with its proper type and name
      return knownColor;
    }

    // Otherwise, return as a true color
    return ColorItem(
      type: .trueColor,
      color: color,
      name: null,
      listPosition: randomColorCode,
    );
  }

  /// The number of possible true colors (0x000000 to 0xFFFFFF).
  @override
  int get length => 0xFFFFFF + 1;

  /// Returns the true color at the given index.
  ///
  /// If the color at the given index exists in the known color catalogs, returns a
  /// ColorItem with the proper type and name. Otherwise, returns a true color ColorItem.
  @override
  ColorItem elementAt(int index) {
    if (index < 0 || index > 0xFFFFFF) {
      throw RangeError('Index must be between 0 and 16777215 (0xFFFFFF)');
    }

    final color = Color(color_utils.withFullAlpha(index));

    // Check if this color exists in any known catalog
    final knownColor = color_lookup.findKnownColor(color);
    if (knownColor != null) {
      // Return the known color with its proper type and name
      return knownColor;
    }

    // Otherwise, return as a true color
    return ColorItem(
      type: .trueColor,
      color: color,
      name: null,
      listPosition: index,
    );
  }
}
