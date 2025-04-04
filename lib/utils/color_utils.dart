// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// A collection of utility functions for working with colors.
library;

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'utils.dart' as utils;

/// Returns the given [Color] with full alpha (0xFF).
int withFullAlpha(int colorCode) {
  return colorCode | 0xFF000000;
}

/// Returns the black or white contrast color of the given [Color].
Color contrastColor(Color color) {
  switch (ThemeData.estimateBrightnessForColor(color)) {
    case Brightness.light:
      return Colors.black;
    case Brightness.dark:
      return Colors.white;
  }
}

/// Returns a contrast color for the given [Color] that is suitable for use as an icon color.
///
/// Based on https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/expand_icon.dart#L155
Color contrastIconColor(Color color) {
  switch (ThemeData.estimateBrightnessForColor(color)) {
    case Brightness.light:
      return Colors.black54;
    case Brightness.dark:
      return Colors.white60;
  }
}

/// Returns the hexadecimal string representation of the given [Color].
String toHexString(Color color, {bool withHash = true}) {
  final String hex = (color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
  return withHash ? '#$hex' : hex;
}

/// Returns the hexadecimal string representation of the given [Color].
String codeToHex(int colorCode, {bool withHash = true}) {
  final String hex = (colorCode & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
  return withHash ? '#$hex' : hex;
}

/// Returns the RGB string representation of the given [Color].
String toRGBString(Color color) {
  return 'rgb(${(color.r * 255).round()}, ${(color.g * 255).round()}, ${(color.b * 255).round()})';
}

/// Returns the HSV string representation of the given [Color].
String toHSVString(Color color) {
  HSVColor hsvColor = HSVColor.fromColor(color);
  return 'hsv(${hsvColor.hue.toStringAsFixed(0)}, ${(hsvColor.saturation * 100).toStringAsFixed(0)}%, ${(hsvColor.value * 100).toStringAsFixed(0)}%)';
}

/// Returns the HSL string representation of the given [Color].
String toHSLString(Color color) {
  HSLColor hslColor = HSLColor.fromColor(color);
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

/// Converts an opaque hexadecimal color string into a Color value.
///
/// Handles 3 digit (#RGB) and 6 digit (#RRGGBB) hex codes (without the alpha channel), with or without the leading
/// hash character (#). Returns null if the hex string is null or invalid.
Color? rgbHexToColor(String? hex) {
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

/// Builds a color swatch image of the given [color] with the specified [width] and [height].
Future<Uint8List> buildColorSwatch(Color color, int width, int height) async {
  // Create the color swatch using a sequence of graphical operations
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
  canvas.drawColor(color, BlendMode.src);
  final ui.Picture picture = recorder.endRecording();

  // Convert the picture to a PNG image and return its bytes
  final ui.Image img = await picture.toImage(width, height);
  final ByteData? pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return pngBytes!.buffer.asUint8List();
}
