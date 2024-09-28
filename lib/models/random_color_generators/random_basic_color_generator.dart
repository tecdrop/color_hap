// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

/// Implements a generator of random basic colors.
library;

import 'dart:math';
import 'package:flutter/material.dart';

import '../color_type.dart';
import '../more.dart';
import '../random_color.dart';

/// Generates a random basic color.
///
/// The returned [RandomColor] has both a [Color] value and a name.
RandomColor nextRandomColor(Random random) {
  final int randomIndex = random.nextInt(kBasicColors.length);
  final ColorWithName basicColor = kBasicColors.elementAt(randomIndex);

  return RandomColor(
    type: ColorType.basicColor,
    color: Color(basicColor.code),
    name: basicColor.name,
    listPosition: randomIndex,
  );
}

/// The number of available basic colors that can be used to generate the random color.
int get possibilityCount => kBasicColors.length;

/// A list of the 12 basic colors with their RGB values and names.
///
/// Imported from the [the 12 RGB C O L O R S](https://www.1728.org/RGB.htm).
const List<ColorWithName> kBasicColors = [
  (code: 0XFF000000, name: 'black'),
  (code: 0XFFFFFFFF, name: 'white'),
  (code: 0XFFFF0000, name: 'red'),
  (code: 0XFF00FF00, name: 'green'),
  (code: 0XFF0000FF, name: 'blue'),
  (code: 0XFFFFFF00, name: 'yellow'),
  (code: 0XFFFF00FF, name: 'magenta'),
  (code: 0XFF00FFFF, name: 'cyan'),
  (code: 0XFFFF8800, name: 'orange'),
  (code: 0XFFFF0080, name: 'rose'),
  (code: 0XFF88FF00, name: 'chartreuse'),
  (code: 0XFF8800FF, name: 'violet'),
  (code: 0XFF00FF88, name: 'spring green'),
  (code: 0XFF0088FF, name: 'azure'),
];
