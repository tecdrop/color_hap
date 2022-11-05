// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// This file implements a generator of random basic colors.

import 'dart:math';
import 'package:flutter/material.dart';

import '../random_color.dart';

/// Generates a random basic color.
///
/// The returned [RandomColor] has both a [Color] value and a name.
RandomColor nextRandomColor(Random random) {
  final int randomIndex = random.nextInt(_basicColors.length);
  final namedColor = _basicColors.entries.elementAt(randomIndex);

  return RandomColor(
    color: Color(namedColor.key),
    name: namedColor.value,
    type: ColorType.basicColor,
  );
}

/// Returns the name of the given [Color], if the color is a valid basic color.
String? getColorName(Color color) => _basicColors[color.value];

/// The number of available basic colors that can be used to generate the random color.
int get possibilityCount => _basicColors.length;

// cSpell: disable

/// A map of integer [Color] value constants corresponding to basic named colors.
///
/// Imported from the [the 12 RGB C O L O R S](https://www.1728.org/RGB.htm).
const Map<int, String> _basicColors = {
  0XFF000000: 'black',
  0XFFFFFFFF: 'white',
  0XFFFF0000: 'red',
  0XFF00FF00: 'green',
  0XFF0000FF: 'blue',
  0XFFFFFF00: 'yellow',
  0XFFFF00FF: 'magenta',
  0XFF00FFFF: 'cyan',
  0XFFFF8800: 'orange',
  0XFFFF0080: 'rose',
  0XFF88FF00: 'chartreuse',
  0XFF8800FF: 'violet',
  0XFF00FF88: 'spring green',
  0XFF0088FF: 'azure',
};
