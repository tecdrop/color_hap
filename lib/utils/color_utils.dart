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
  static String toHexString(Color color, {bool withHash = true}) {
    final String hex = (color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
    return withHash ? '#$hex' : hex;
  }

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

  /// Converts an opaque hexadecimal color string into a Color value.
  ///
  /// Handles 3 digit (#RGB) and 6 digit (#RRGGBB) hex codes (without the alpha channel), with or without the leading
  /// hash character (#). Returns null if the hex string is null or invalid.
  static Color? rgbHexToColor(String? hex) {
    // Return null if the hex string is null.
    if (hex == null) {
      return null;
    }

    // Remove the leading '#' if it exists.
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }

    // Handle 3 digit hex codes (e.g. #FFF) by duplicating each digit.
    if (hex.length == 3) {
      hex = hex.split('').map((String c) => c + c).join();
    }

    // Convert the hex string to a fully opaque Color.
    if (hex.length == 6) {
      // return Color(int.parse(hex, radix: 16) + 0xFF000000);
      int? parsed = int.tryParse(hex, radix: 16);
      if (parsed != null) {
        return Color(parsed + 0xFF000000);
      }
    }

    // Return null if the hex string is invalid.
    return null;
  }
}
