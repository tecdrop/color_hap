// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

/// An enum to specify the different kinds of random colors.
enum ColorType {
  mixedColor,
  basicColor,
  webColor,
  namedColor,
  attractiveColor,
  trueColor,
}

/// A map of [ColorType] values to their string representation.
const Map<ColorType, String> colorTypeIds = <ColorType, String>{
  ColorType.mixedColor: '',
  ColorType.basicColor: 'basic',
  ColorType.webColor: 'web',
  ColorType.namedColor: 'named',
  ColorType.attractiveColor: 'attractive',
  ColorType.trueColor: 'true',
};

/// Parses the given [ColorType] ID string into a [ColorType] value.
///
/// If the string is not a valid ID, a default value of [ColorType.mixedColor] is returned.
ColorType parseColorType(String? value) {
  return colorTypeIds.entries
      .firstWhere(
        (MapEntry<ColorType, String> entry) => entry.value == value,
        orElse: () => colorTypeIds.entries.first,
      )
      .key;
}

/// Converts the given [ColorType] value into a [ColorType] string ID.
String colorTypeToString(ColorType colorType) {
  return colorTypeIds[colorType] ?? (throw ArgumentError('$colorType does not have a string ID'));
}
