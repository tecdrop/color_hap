// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

/// Implements a generator of random true colors.
library;

import 'dart:math';
import 'package:flutter/material.dart';

/// Generates a random true color.
Color nextRandomColor(Random random) {
  return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1.0);
}

/// The number of available true colors that can be used to generate the random color.
///
/// This is the total number of colors can be represented in a 24-bit color palette.
int get possibilityCount => 0xFFFFFF;
