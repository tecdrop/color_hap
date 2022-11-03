// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// cSpell:ignore flutter_randomcolor, fromRGBO

import 'package:flutter/material.dart';

import 'package:flutter_randomcolor/flutter_randomcolor.dart' as frc;

import 'nameable_color.dart';
import 'random_color.dart';

/// A generator of random attractive colors.
class RandomAttractiveColor extends RandomColor {
  /// Generates a random attractive color.
  ///
  /// The returned [NameableColor] has a [Color] value, but may also have a color name, as it is
  /// tested to see if it matches the built-in maps of named colors.
  @override
  NameableColor next() {
    final frc.Options options =
        frc.Options(format: frc.Format.rgbArray, luminosity: frc.Luminosity.light);
    final rgb = frc.RandomColor.getColor(options);
    final Color color = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);

    return RandomColor.getNamedColor(color, ColorType.attractiveColor);
  }

  // Because of the algorithm that is used by the flutter_randomcolor plugin, can we really compute
  // the number of available attractive colors that can be used to generate the random color?
  // static int get possibilities => 0xFFFFFF;
}
