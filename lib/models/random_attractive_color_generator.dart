// Copyright 2020-2022 Tecdrop. All rights reserved.
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
