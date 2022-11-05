// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// This file implements a generator of random true colors.

// cSpell:ignore fromRGBO

import 'dart:math';
import 'package:flutter/material.dart';

/// Generates a random true color.
Color nextRandomColor(Random random) {
  // Uncomment one of the following lines to test color matching of built-in maps of named colors.
  // return const Color(0XFFFF0080); // rose basic color
  // return const Color(0xFFDDA0DD); // plum web color
  // return const Color(0xFF026395); // Bahama Blue named color

  return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1.0);
  // return RandomColor.getNamedColor(color, ColorType.trueColor);
}

/// The number of available true colors that can be used to generate the random color.
///
/// This is the total number of colors can be represented in a 24-bit color palette.
int get possibilityCount => 0xFFFFFF;
