// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// cSpell:ignore racg, rncg, rtcg, rwcg

import 'dart:math';
import 'package:flutter/material.dart';

import 'random_color_generators/random_attractive_color_generator.dart' as racg;
import 'random_color_generators/random_named_color_generator.dart' as rncg;
import 'random_color_generators/random_true_color_generator.dart' as rtcg;
import 'random_color_generators/random_web_color_generator.dart' as rwcg;
import 'random_color.dart';

/// The private random number generator used to generate random colors.
final Random _random = _createRandom();

Random _createRandom({bool secure = true}) {
  Random random;
  try {
    random = secure ? Random.secure() : Random();
  } on UnsupportedError {
    random = Random();
  }

  return random;
}

/// Returns a [RandomColor] from the given [Color].
///
/// The returned random color has a name if the color value matches the built-in maps of named
/// colors.
RandomColor _getNamedColor(Color color, ColorType defaultType) {
  final String? webColorName = rwcg.getColorName(color);
  if (webColorName != null) {
    return RandomColor(color: color, name: webColorName, type: ColorType.webColor);
  }

  final String? namedColorName = rncg.getColorName(color);
  if (namedColorName != null) {
    return RandomColor(color: color, name: namedColorName, type: ColorType.namedColor);
  }

  return RandomColor(color: color, type: defaultType);
}

/// Generates a random color based on the given color type.
///
/// The returned [RandomColor] has a name if it was generated from named colors, or if its color
/// value matches the built-in maps of named colors.
RandomColor nextRandomColor(ColorType colorType) {
  switch (colorType) {
    case ColorType.webColor:
      return rwcg.nextRandomColor(_random);
    case ColorType.namedColor:
      return rncg.nextRandomColor(_random);
    case ColorType.attractiveColor:
      return _getNamedColor(racg.nextRandomColor(_random), ColorType.attractiveColor);
    case ColorType.trueColor:
      return _getNamedColor(rtcg.nextRandomColor(_random), ColorType.trueColor);
  }
}

/// The number of available colors of the given type that can be used to generate the random color.
int possibilityCount(ColorType colorType) {
  switch (colorType) {
    case ColorType.webColor:
      return rwcg.possibilityCount;
    case ColorType.namedColor:
      return rncg.possibilityCount;
    case ColorType.attractiveColor:
      return racg.possibilityCount;
    case ColorType.trueColor:
      return rtcg.possibilityCount;
  }
}
