// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

/// An enhanced enum to specify the different kinds of random colors.
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
    return _shortStrings[this] ?? (throw ArgumentError('No short string representation for $this'));
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
