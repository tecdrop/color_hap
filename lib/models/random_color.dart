// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

/// An enum to specify the different kinds of random colors.
enum ColorType {
  mixedColor,
  basicColor,
  webColor,
  namedColor,
  attractiveColor,
  trueColor,
}

/// A random color with a [Color] value, possibly a color name, and a color type.
class RandomColor {
  const RandomColor({
    required this.color,
    required this.type,
    this.name,
  });

  /// The color value.
  final Color color;

  /// The color name. Can be null if the color is not a named color.
  final String? name;

  /// The type of color: web, named, attractive, or a true color.
  final ColorType type;

  /// The "title" of the this [RandomColor].
  ///
  /// Returns the color name and hex code, or only the hex code if the color doesn't have a name.
  String get title {
    final String hexString = ColorUtils.toHexString(color);
    return name != null ? '$name $hexString' : hexString;
  }
}
