// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// cSpell:ignore fromRGBO

import 'package:flutter/material.dart';

import 'nameable_color.dart';
import 'random_color.dart';

/// A generator of random true colors.
class RandomTrueColor extends RandomColor {
  /// Generates a random true color.
  ///
  /// The returned [NameableColor] has a [Color] value, but may also have a color name, as it is
  /// tested to see if it matches the built-in maps of named colors.
  @override
  NameableColor next() {
    // const Color color = Color(0xFF48D1CC);
    final Color color = Color.fromRGBO(
      RandomColor.random.nextInt(256),
      RandomColor.random.nextInt(256),
      RandomColor.random.nextInt(256),
      1.0,
    );
    return RandomColor.getNamedColor(color, ColorType.trueColor);
  }

  /// The number of available true colors that can be used to generate the random color.
  ///
  /// This is the total number of colors can be represented in a 24-bit color palette.
  static int get possibilities => 0xFFFFFF;
}
