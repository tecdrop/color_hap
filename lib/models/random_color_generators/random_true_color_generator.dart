// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

/// Implements a generator of random true colors.
library;

import 'dart:math';
import 'package:flutter/material.dart';

import '../../utils/color_utils.dart' as color_utils;
import '../color_type.dart';
import '../random_color.dart';

/// Generates a random true color.
RandomColor nextRandomColor(Random random) {
  // Generate a random 24-bit color code, which is a number between 0x000000 and 0xFFFFFF
  final int randomColorCode = random.nextInt(0xFFFFFF + 1);

  return RandomColor(
    type: ColorType.trueColor,
    color: Color(color_utils.withFullAlpha(randomColorCode)),
    name: null,
    listPosition: randomColorCode,
  );
}

/// The number of available true colors that can be used to generate the random color.
///
/// This is the total number of colors can be represented in a 24-bit color palette.
int get possibilityCount => 0xFFFFFF;
