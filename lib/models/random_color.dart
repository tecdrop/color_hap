// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

import 'nameable_color.dart';
import 'random_attractive_color.dart';
import 'random_named_color.dart';
import 'random_true_color.dart';
import 'random_web_color.dart';

/// An enum to specify the different kinds of random colors.
enum ColorType {
  webColor,
  namedColor,
  attractiveColor,
  trueColor,
}

/// An abstract generator of random colors.
abstract class RandomColor {
  RandomColor();

  /// The private random number generator used to generate random colors.
  static final Random random = _createRandom();

  static Random _createRandom({bool secure = true}) {
    Random random;
    try {
      random = secure ? Random.secure() : Random();
    } on UnsupportedError {
      random = Random();
    }

    return random;
  }

  /// Generates a random color.
  ///
  /// Override this method to implement random color generation.
  NameableColor next();

  /// Returns a [NameableColor] from the given [Color].
  ///
  /// The returned nameable color has a name if the color value matches the built-in maps of named
  /// colors.
  static NameableColor getNamedColor(Color color, ColorType defaultType) {
    final NameableColor? webColor = RandomWebColor.getNamedColor(color);
    if (webColor != null) return webColor;

    final NameableColor? namedColor = RandomNamedColor.getNamedColor(color);
    if (namedColor != null) return namedColor;

    return NameableColor(color: color, type: defaultType);
  }

  /// Factory which returns a [RandomColor] generator based on the provided [colorType].
  factory RandomColor.fromType(ColorType colorType) {
    switch (colorType) {
      case ColorType.webColor:
        return RandomWebColor();
      case ColorType.namedColor:
        return RandomNamedColor();
      case ColorType.attractiveColor:
        return RandomAttractiveColor();
      case ColorType.trueColor:
        return RandomTrueColor();
    }
  }
}
