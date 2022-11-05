// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

import 'nameable_color.dart';
import 'random_attractive_color.dart' as rac;
import 'random_named_color.dart' as rnc;
import 'random_true_color.dart' as rtc;
import 'random_web_color.dart' as rwc;

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

/// Returns a [NameableColor] from the given [Color].
///
/// The returned nameable color has a name if the color value matches the built-in maps of named
/// colors.
NameableColor _getNamedColor(Color color, ColorType defaultType) {
  final String? webColorName = rwc.getColorName(color);
  if (webColorName != null) {
    return NameableColor(color: color, name: webColorName, type: ColorType.webColor);
  }

  final String? namedColorName = rnc.getColorName(color);
  if (namedColorName != null) {
    return NameableColor(color: color, name: namedColorName, type: ColorType.namedColor);
  }

  return NameableColor(color: color, type: defaultType);
}

/// Generates a random color based on the given color type.
///
/// The returned [NameableColor] has a name if it was generated from named colors, or if its color
/// value matches the built-in maps of named colors.
NameableColor nextRandomColor(ColorType colorType) {
  switch (colorType) {
    case ColorType.webColor:
      return rwc.nextRandomColor(_random);
    case ColorType.namedColor:
      return rnc.nextRandomColor(_random);
    case ColorType.attractiveColor:
      return _getNamedColor(rac.nextRandomColor(_random), ColorType.attractiveColor);
    case ColorType.trueColor:
      return _getNamedColor(rtc.nextRandomColor(_random), ColorType.trueColor);
  }
}

/// The number of available colors of the given type that can be used to generate the random color.
int possibilityCount(ColorType colorType) {
  switch (colorType) {
    case ColorType.webColor:
      return rwc.possibilityCount;
    case ColorType.namedColor:
      return rnc.possibilityCount;
    case ColorType.attractiveColor:
      return rac.possibilityCount;
    case ColorType.trueColor:
      return rtc.possibilityCount;
  }
}
