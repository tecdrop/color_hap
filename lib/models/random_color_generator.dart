// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// cSpell:ignore rbcg, racg, rncg, rtcg, rwcg

import 'dart:math';
import 'package:flutter/material.dart';

import 'color_type.dart';
import 'random_color_generators/random_attractive_color_generator.dart' as racg;
import 'random_color_generators/random_basic_color_generator.dart' as rbcg;
import 'random_color_generators/random_named_color_generator.dart' as rncg;
import 'random_color_generators/random_true_color_generator.dart' as rtcg;
import 'random_color_generators/random_web_color_generator.dart' as rwcg;
import 'random_color.dart';

/// The private random number generator used to generate random colors.
final Random _random = _createRandom();

/// A subjective list of [ColorType]s used to give some color types more "weight" when generating
/// mixed random colors.
final List<ColorType> _typeWeights = _initTypeWeights();

/// Creates a secure or insecure random number generator depending on the given [secure] parameter.
Random _createRandom({bool secure = true}) {
  Random random;
  try {
    random = secure ? Random.secure() : Random();
  } on UnsupportedError {
    random = Random();
  }

  return random;
}

/// Initializes the subjective list of [ColorType]s used to give some color types more "weight"
/// when generating mixed random colors.
List<ColorType> _initTypeWeights() {
  final List<ColorType> typeWeights = [];

  // Current weight distribution: 1-3-6-5-5
  // Previously 1-2-3-3-3
  typeWeights.add(ColorType.basicColor);
  typeWeights.addAll(List.filled(3, ColorType.webColor));
  typeWeights.addAll(List.filled(6, ColorType.namedColor));
  typeWeights.addAll(List.filled(5, ColorType.attractiveColor));
  typeWeights.addAll(List.filled(5, ColorType.trueColor));
  return typeWeights;
}

/// Returns a [RandomColor] from the given [Color].
///
/// The returned random color has a name if the color value matches the built-in maps of named
/// colors.
RandomColor _getNamedColor(Color color, ColorType defaultType) {
  final String? basicColorName = rbcg.getColorName(color);
  if (basicColorName != null) {
    return RandomColor(color: color, name: basicColorName, type: ColorType.basicColor);
  }

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
  // For debugging purposes
  // if (colorType != ColorType.randomColor) print(colorType);
  // print(_typeWeights);

  // Hard-coded colors for taking screenshots
  // return const RandomColor(color: Color(0XFF0088FF), name: 'azure', type: ColorType.basicColor);
  // return const RandomColor(color: Color(0xFF8700FE), type: ColorType.trueColor);
  // return const RandomColor(color: Color(0xFFFFEC13), name: 'Broom', type: ColorType.namedColor);
  // return const RandomColor(color: Color(0xFF00FF22), type: ColorType.trueColor);
  // return const RandomColor(color: Color(0XFFFF0000), name: 'red', type: ColorType.basicColor);
  // return const RandomColor(color: Color(0XFFFF00FF), name: 'magenta', type: ColorType.basicColor);
  return const RandomColor(color: Color(0XFF8800FF), name: 'violet', type: ColorType.basicColor);

  switch (colorType) {
    case ColorType.mixedColor:
      return nextRandomColor(_typeWeights[_random.nextInt(_typeWeights.length)]);
    case ColorType.basicColor:
      return rbcg.nextRandomColor(_random);
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
    case ColorType.mixedColor:
      return rtcg.possibilityCount; // The possibility count is the same as of True colors
    case ColorType.basicColor:
      return rbcg.possibilityCount;
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
