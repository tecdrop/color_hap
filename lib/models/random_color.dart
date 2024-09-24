// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../utils/color_utils.dart' as color_utils;
import 'color_type.dart';

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

  /// The type of this random color.
  final ColorType type;

  /// The "title" of the this [RandomColor].
  ///
  /// Returns the color name and hex code, or only the hex code if the color doesn't have a name.
  String get title {
    final String hexString = color_utils.toHexString(color);
    return name != null ? '$name $hexString' : hexString;
  }

  /// Overrides the equality operator to compare two [RandomColor] objects.
  /// Two [RandomColor] objects are equal if they have the same color value, name, and type.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RandomColor &&
            runtimeType == other.runtimeType &&
            color == other.color &&
            name == other.name &&
            type == other.type;
  }

  /// Overrides the hash code getter to return the hash code of this [RandomColor].
  @override
  int get hashCode {
    return color.hashCode ^ name.hashCode ^ type.hashCode;
  }

  /// Creates a [RandomColor] from a JSON object.
  RandomColor.fromJson(Map<String, dynamic> json)
      : color = Color(json['color']),
        name = json['name'],
        type = ColorType.values[json['type']];

  /// Converts this [RandomColor] to a JSON object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'color': color.value,
      'name': name,
      'type': type.index,
    };
  }

  /// Converts this [RandomColor] to a CSV string.
  String toCsvString() {
    return [
      color_utils.toHexString(color),
      name ?? '',
      type.toShortString(),
    ].join(',');
  }
}
