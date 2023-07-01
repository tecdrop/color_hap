// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

/// Color utility functions.
class ColorUtils {
  ColorUtils._();

  /// Returns the black or white contrast color of the given [Color].
  static Color contrastOf(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light ? Colors.black : Colors.white;

  /// Returns the hexadecimal string representation of the given [Color].
  static String toHexString(Color color) =>
      '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  /// Returns the RGB string representation of the given [Color].
  static String toRGBString(Color color) => 'rgb(${color.red}, ${color.green}, ${color.blue})';

  /// Returns the HSV string representation of the given [Color].
  static String toHSVString(Color color) {
    HSVColor hsvColor = HSVColor.fromColor(color);
    return 'hsv(${hsvColor.hue.toStringAsFixed(0)}, ${(hsvColor.saturation * 100).toStringAsFixed(0)}%, ${(hsvColor.value * 100).toStringAsFixed(0)}%)';
  }

  /// Returns the HSL string representation of the given [Color].
  static String toHSLString(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    return 'hsl(${hslColor.hue.toStringAsFixed(0)}, ${(hslColor.saturation * 100).toStringAsFixed(0)}%, ${(hslColor.lightness * 100).toStringAsFixed(0)}%)';
  }

  /// Returns the decimal string representation of the given [Color] value.
  static String toDecimalString(Color color) {
    return Utils.intToCommaSeparatedString(color.withAlpha(0).value);
  }

  /// Returns the string representation of the relative luminance of the given [Color].
  static String luminanceString(Color color) {
    return color.computeLuminance().toStringAsFixed(5);
  }

  /// Returns the string representation (`light` or `dark`) of the brightness of the given [Color].
  static String brightnessString(Color color) {
    return describeEnum(ThemeData.estimateBrightnessForColor(color));
  }
}
