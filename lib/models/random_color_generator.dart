// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../utils/color_utils.dart' as color_utils;
import 'color_type.dart';
import 'more.dart';
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

/// A blacklist of all the codes of the basic, web & named colors, used to avoid generating true
/// colors that are already in these lists.
final Set<int> _colorsWithNameBlacklist = _initColorsWithNameBlacklist();

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

/// Creates the blacklist of all the codes of the basic, web & named colors.
///
/// This is used to avoid generating true colors that are already in these lists.
Set<int> _initColorsWithNameBlacklist() {
  final Set<int> colorCodes = <int>{};
  for (final ColorWithName color in rbcg.kBasicColors) {
    colorCodes.add(color.code);
  }
  for (final ColorWithName color in rwcg.kWebColors) {
    colorCodes.add(color.code);
  }
  for (final ColorWithName color in rncg.kNamedColors) {
    colorCodes.add(color.code);
  }
  print('colorCodes length: ${colorCodes.length}');
  return colorCodes;
}

/// Generates a random color based on the given color type.
///
/// The returned [RandomColor] has a name if it was generated from named colors, or if its color
/// value matches the built-in maps of named colors.
RandomColor nextRandomColor(ColorType colorType) {
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
      return racg.nextRandomColor(_random);
    case ColorType.trueColor:
      return rtcg.nextRandomColor(_random, blacklist: _colorsWithNameBlacklist);
  }
}

int _nextIdentityColorIndex = 0;

/// Returns the next identity color from a list of predefined colors.
///
/// These colors are used internally for app screenshots and branding.
RandomColor nextIdentityColor() {
  const List<RandomColor> identityColors = [
    RandomColor(type: ColorType.basicColor, color: Color(0XFF0088FF), name: 'azure'),
    RandomColor(type: ColorType.trueColor, color: Color(0xFF8700FE)),
    RandomColor(type: ColorType.namedColor, color: Color(0xFFFFEC13), name: 'Broom'),
    RandomColor(type: ColorType.trueColor, color: Color(0xFF00FF22)),
    RandomColor(type: ColorType.basicColor, color: Color(0XFFFF0000), name: 'red'),
    RandomColor(type: ColorType.basicColor, color: Color(0XFFFF00FF), name: 'magenta'),
    RandomColor(type: ColorType.basicColor, color: Color(0XFF8800FF), name: 'violet'),
  ];

  final RandomColor randomColor = identityColors[_nextIdentityColorIndex];
  _nextIdentityColorIndex = (_nextIdentityColorIndex + 1) % identityColors.length;
  return randomColor;
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

RandomColor getRandomColor(ColorType colorType, int index) {
  switch (colorType) {
    case ColorType.mixedColor:
      throw UnsupportedError('getRandomColor does not support mixed colors.');
    case ColorType.basicColor:
      final ColorWithName item = rbcg.kBasicColors.elementAt(index);
      return RandomColor(
        type: colorType,
        color: Color(item.code),
        name: item.name,
        listPosition: index,
      );

    case ColorType.webColor:
      final ColorWithName item = rwcg.kWebColors.elementAt(index);
      return RandomColor(
        type: colorType,
        color: Color(item.code),
        name: item.name,
        listPosition: index,
      );
    case ColorType.namedColor:
      final ColorWithName item = rncg.kNamedColors.elementAt(index);
      return RandomColor(
        type: colorType,
        color: Color(item.code),
        name: item.name,
        listPosition: index,
      );
    case ColorType.attractiveColor:
      final int colorCode = racg.kAttractiveColors[index];
      return RandomColor(
        type: colorType,
        color: Color(colorCode),
        name: null,
        listPosition: index,
      );
    case ColorType.trueColor:
      final int colorCode = color_utils.withFullAlpha(index);
      return RandomColor(
        type: colorType,
        color: Color(colorCode),
        name: null,
        listPosition: index,
      );
  }
}
