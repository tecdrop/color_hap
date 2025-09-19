// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../utils/color_utils.dart' as color_utils;
import 'color_type.dart';

/// A random color with a [Color] value, possibly a color name, and a color type.
class ColorItem {
  const ColorItem({required this.type, required this.color, this.name, this.listPosition});

  /// The type of this random color.
  final ColorType type;

  /// The color value.
  final Color color;

  /// The color name. Can be null if the color is not a named color.
  final String? name;

  /// The position of this [ColorItem] in the source list.
  final int? listPosition;

  /// The "long title" of the this [ColorItem].
  ///
  /// Returns the color name and hex code, or only the hex code if the color doesn't have a name.
  String get longTitle {
    final String hexString = color_utils.toHexString(color);
    return name != null ? '$name $hexString' : hexString;
  }

  /// The title of this [ColorItem].
  ///
  /// Returns the color name if it exists, or the hex code otherwise.
  String get title {
    final String hexString = color_utils.toHexString(color);
    return name != null ? name! : hexString;
  }

  /// The hex string of this [ColorItem].
  String get hexString => color_utils.toHexString(color);

  /// Overrides the equality operator to compare two [ColorItem] objects.
  /// Two [ColorItem]s are equal if they have the same color type, color, name, and list position.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ColorItem &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            color == other.color &&
            name == other.name &&
            listPosition == other.listPosition;
  }

  /// Overrides the hash code getter to return the hash code of this [ColorItem].
  @override
  int get hashCode {
    return type.hashCode ^ color.hashCode ^ (name?.hashCode ?? 0) ^ (listPosition?.hashCode ?? 0);
  }

  /// Creates a [ColorItem] from a JSON object.
  ColorItem.fromJson(Map<String, dynamic> json)
    : type = ColorType.values[json['type']],
      color = Color(json['color']),
      name = json['name'],
      listPosition = json['listPosition'];

  /// Converts this [ColorItem] to a JSON object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.index,
      'color': color.toARGB32(),
      'name': name,
      'listPosition': listPosition,
    };
  }

  /// Converts this [ColorItem] to a CSV string.
  String toCsvString() {
    return [hexString, name ?? '', type.name].join(',');
  }
}
