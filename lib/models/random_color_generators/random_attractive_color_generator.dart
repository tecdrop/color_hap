// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// This file implements a generator of random attractive colors.

// cSpell:ignore flutter_randomcolor, fromRGBO

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_randomcolor/flutter_randomcolor.dart' as frc;

/// Generates a random attractive color.

// TODO: Use the app's random number generator provided as a parameter to generate the attractive
// colors. Currently the `flutter_randomcolor` does not support this.
Color nextRandomColor(Random random) {
  // Uncomment one of the following lines to test color matching of built-in maps of named colors.
  // return const Color(0XFF0088FF); // azure basic color
  // return const Color(0xFF800000); // maroon web color and Maroon named color
  // return const Color(0xFF831923); // Merlot named color

  final frc.Options options = frc.Options(
    format: frc.Format.rgbArray,
    luminosity: frc.Luminosity.light,
  );
  final rgb = frc.RandomColor.getColor(options);
  return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);
}

// Because of the algorithm that is used by the flutter_randomcolor plugin, can we really compute
// the exact number of available attractive colors that can be used to generate the random color?
int get possibilityCount => 0xFFFFFF;
