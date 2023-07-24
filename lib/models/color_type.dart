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
  trueColor;

  const ColorType();

  /// Creates a [ColorType] from a short string representation.
  factory ColorType.fromShortString(String? value) {
    return _shortStrings.entries
        .firstWhere(
          (MapEntry<ColorType, String> entry) => entry.value == value,
          orElse: () => _shortStrings.entries.first,
        )
        .key;
  }

  /// Returns a short string representation of this [ColorType].
  String toShortString() {
    return _shortStrings[this] ??
        (throw ArgumentError('$this does not have a short string representation'));
  }

  /// A map of [ColorType] values to their short string representation.
  static const Map<ColorType, String> _shortStrings = <ColorType, String>{
    ColorType.mixedColor: 'mixed',
    ColorType.basicColor: 'basic',
    ColorType.webColor: 'web',
    ColorType.namedColor: 'named',
    ColorType.attractiveColor: 'attractive',
    ColorType.trueColor: 'true',
  };
}

// /// A map of [ColorType] values to their string representation.
// const Map<ColorType, String> colorTypeIds = <ColorType, String>{
//   // ColorType.mixedColor: '',
//   ColorType.mixedColor: 'mixed',
//   ColorType.basicColor: 'basic',
//   ColorType.webColor: 'web',
//   ColorType.namedColor: 'named',
//   ColorType.attractiveColor: 'attractive',
//   ColorType.trueColor: 'true',
// };

/// Parses the given [ColorType] ID string into a [ColorType] value.
///
/// If the string is not a valid ID, a default value of [ColorType.mixedColor] is returned.
// ColorType parseColorType(String? value) {
//   return colorTypeIds.entries
//       .firstWhere(
//         (MapEntry<ColorType, String> entry) => entry.value == value,
//         orElse: () => colorTypeIds.entries.first,
//       )
//       .key;
// }

// /// Converts the given [ColorType] value into a [ColorType] string ID.
// String colorTypeToString(ColorType colorType) {
//   return colorTypeIds[colorType] ?? (throw ArgumentError('$colorType does not have a string ID'));
// }
