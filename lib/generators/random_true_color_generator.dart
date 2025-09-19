// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'dart:ui';

import '../../utils/color_utils.dart' as color_utils;
import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';

/// A random color generator that generates random true colors (24-bit colors).
class RandomTrueColorGenerator implements RandomColorGenerator {
  @override
  ColorType get colorType => ColorType.trueColor;

  /// Generates a random true color.
  @override
  ColorItem next(Random random) {
    // Generate a random 24-bit color code, which is a number between 0x000000 and 0xFFFFFF
    final int randomColorCode = random.nextInt(0xFFFFFF + 1);

    return ColorItem(
      type: ColorType.trueColor,
      color: Color(color_utils.withFullAlpha(randomColorCode)),
      name: null,
      listPosition: randomColorCode,
    );
  }

  /// The number of possible true colors (0x000000 to 0xFFFFFF).
  @override
  int get length => 0xFFFFFF + 1;

  /// Returns the true color at the given index.
  @override
  ColorItem elementAt(int index) {
    if (index < 0 || index > 0xFFFFFF) {
      throw RangeError('Index must be between 0 and 16777215 (0xFFFFFF)');
    }

    return ColorItem(
      type: ColorType.trueColor,
      color: Color(color_utils.withFullAlpha(index)),
      name: null,
      listPosition: index,
    );
  }
}
