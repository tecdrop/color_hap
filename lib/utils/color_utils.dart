// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// A collection of utility functions for working with colors.
library;

import 'package:flutter/material.dart';

import '../common/types.dart';
import 'utils.dart' as utils;

// -----------------------------------------------------------------------------------------------
// Color channel manipulations
// -----------------------------------------------------------------------------------------------

/// Returns the given [Color] with full alpha (0xFF).
int withFullAlpha(int colorCode) {
  return colorCode | 0xFF000000;
}

/// Returns the given [Color] without the alpha channel (0x00).
int toRGB24(Color color) {
  return color.toARGB32() & 0x00FFFFFF;
}

/// Returns a new Color with the specified RGB channel set to the given value.
Color withRGBChannel(Color color, RGBChannel channel, int value) {
  final clampedValue = value.clamp(0, 255);
  return switch (channel) {
    .red => color.withRed(clampedValue),
    .green => color.withGreen(clampedValue),
    .blue => color.withBlue(clampedValue),
  };
}

/// Returns the value of the specified RGB channel from the given [Color].
int getRGBChannelValue(Color color, RGBChannel channel) {
  return switch (channel) {
    .red => (color.r * 255).round(),
    .green => (color.g * 255).round(),
    .blue => (color.b * 255).round(),
  };
}

/// Returns the black or white contrast color of the given [Color].
Color contrastColor(Color color) {
  return switch (ThemeData.estimateBrightnessForColor(color)) {
    .light => Colors.black,
    .dark => Colors.white,
  };
}

/// Returns a contrast color for the given [Color] that is suitable for use as an icon color.
///
/// Based on https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/expand_icon.dart#L155
Color contrastIconColor(Color color) {
  return switch (ThemeData.estimateBrightnessForColor(color)) {
    .light => Colors.black54,
    .dark => Colors.white60,
  };
}

// -----------------------------------------------------------------------------------------------
// Color hex string conversions
// -----------------------------------------------------------------------------------------------

/// Returns the hexadecimal string representation of the given [Color].
String toHexString(Color color, {bool withHash = true}) {
  final hex = (color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
  return withHash ? '#$hex' : hex;
}

/// Converts an opaque hexadecimal color string into a Color value.
///
/// Handles 3 digit (#RGB) and 6 digit (#RRGGBB) hex codes (without the alpha channel), with or without the leading
/// hash character (#). Returns null if the hex string is null or invalid.
Color? rgbHexToColor(String? hex) {
  // Return null if the hex string is null.
  if (hex == null) {
    return null;
  }

  var hexString = hex;

  // Remove the leading '#' if it exists.
  if (hexString.startsWith('#')) {
    hexString = hexString.substring(1);
  }

  // Handle 3 digit hex codes (e.g. #FFF) by duplicating each digit.
  if (hexString.length == 3) {
    hexString = hexString.split('').map((String c) => c + c).join();
  }

  // Convert the hex string to a fully opaque Color.
  if (hexString.length == 6) {
    // return Color(int.parse(hex, radix: 16) + 0xFF000000);
    final parsed = int.tryParse(hexString, radix: 16);
    if (parsed != null) {
      return Color(parsed + 0xFF000000);
    }
  }

  // Return null if the hex string is invalid.
  return null;
}

// -----------------------------------------------------------------------------------------------
// Color information string conversions
// -----------------------------------------------------------------------------------------------

/// Returns the RGB string representation of the given [Color].
String toRGBString(Color color) {
  return 'rgb(${(color.r * 255).round()}, ${(color.g * 255).round()}, ${(color.b * 255).round()})';
}

/// Returns the HSV string representation of the given [Color].
String toHSVString(Color color) {
  final hsvColor = HSVColor.fromColor(color);
  return 'hsv(${hsvColor.hue.toStringAsFixed(0)}, ${(hsvColor.saturation * 100).toStringAsFixed(0)}%, ${(hsvColor.value * 100).toStringAsFixed(0)}%)';
}

/// Returns the HSL string representation of the given [Color].
String toHSLString(Color color) {
  final hslColor = HSLColor.fromColor(color);
  return 'hsl(${hslColor.hue.toStringAsFixed(0)}, ${(hslColor.saturation * 100).toStringAsFixed(0)}%, ${(hslColor.lightness * 100).toStringAsFixed(0)}%)';
}

/// Returns the decimal string representation of the given [Color] value.
String toDecimalString(Color color) {
  return utils.intToCommaSeparatedString(color.withAlpha(0).toARGB32());
}

/// Returns the string representation of the relative luminance of the given [Color].
String luminanceString(Color color) {
  return color.computeLuminance().toStringAsFixed(5);
}

/// Returns the string representation (`light` or `dark`) of the brightness of the given [Color].
String brightnessString(Color color) {
  return ThemeData.estimateBrightnessForColor(color).name;
}

// -----------------------------------------------------------------------------------------------
// Color variations & effects
// -----------------------------------------------------------------------------------------------

/// Returns a subtle variation of the given [Color] for use as a background or highlight.
Color getSubtleVariation(Color color, {double opacity = 0.12}) {
  return switch (ThemeData.estimateBrightnessForColor(color)) {
    // Mix with white for dark backgrounds
    .dark => Color.lerp(color, Colors.white, opacity)!,
    // Mix with black for light backgrounds
    .light => Color.lerp(color, Colors.black, opacity)!,
  };
}
