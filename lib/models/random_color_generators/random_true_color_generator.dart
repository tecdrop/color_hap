// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// This file implements a generator of random true colors.

// cSpell:ignore fromRGBO

import 'dart:math';
import 'package:flutter/material.dart';

/// Generates a random true color.
Color nextRandomColor(Random random) {
  // Uncomment the following line to test color matching to the built-in maps of named colors.
  // return const Color(0xFF48D1CC);

  return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1.0);
  // return RandomColor.getNamedColor(color, ColorType.trueColor);
}

/// The number of available true colors that can be used to generate the random color.
///
/// This is the total number of colors can be represented in a 24-bit color palette.
int get possibilityCount => 0xFFFFFF;
