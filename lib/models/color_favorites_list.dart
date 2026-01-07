// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../utils/color_utils.dart' as color_utils;
import 'color_item.dart';
import 'color_type.dart';
import 'random_color_generator.dart';

/// A list of favorite random colors.
class ColorFavoritesList {
  ColorFavoritesList({
    this.onChanged,
  });

  /// Callback invoked whenever the list is modified.
  final VoidCallback? onChanged;

  /// The list of [ColorItem] objects in the favorites list.
  final Set<ColorItem> _setOfFavorites = <ColorItem>{};

  /// The number of colors in the favorites list.
  int get length => _setOfFavorites.length;

  /// Returns true if the given [colorItem] is in the favorites list, false otherwise.
  bool contains(ColorItem colorItem) {
    return _setOfFavorites.contains(colorItem);
  }

  /// Adds the given [colorItem] to the favorites list.
  ///
  /// Returns true if the color was added, false if it was already in the list.
  bool add(ColorItem colorItem) {
    final result = _setOfFavorites.add(colorItem);
    if (result) onChanged?.call();
    return result;
  }

  /// Removes the given [colorItem] from the favorites list.
  ///
  /// Returns true if the color was removed, false if it was not in the list.
  bool remove(ColorItem colorItem) {
    final result = _setOfFavorites.remove(colorItem);
    if (result) onChanged?.call();
    return result;
  }

  // /// Returns the index of the given [colorItem] in the favorites list, or -1 if it is not there.
  // int indexOf(ColorItem colorItem) {
  //   return _list.indexOf(colorItem);
  // }

  /// Returns the color at the given [index] in the favorites list.
  // ColorItem elementAt(int index) => _list.elementAt(index);

  // /// Inserts the given [ColorItem] at the given [index] in the favorites list.
  // void insert(int index, ColorItem colorItem) {
  //   _list.insert(index, colorItem);
  //   onChanged?.call();
  // }

  // /// Removes the color at the given [index] from the favorites list.
  // ColorItem removeAt(int index) {
  //   final result = _list.removeAt(index);
  //   onChanged?.call();
  //   return result;
  // }

  /// Clears the favorites list.
  void clear() {
    _setOfFavorites.clear();
    onChanged?.call();
  }

  /// Removes the given [colorItem] from the favorites list if it is already there, or adds it to
  /// the list if it is not.
  ///
  /// Returns the index of the color in the favorites list if it was added, or -1 if it was removed.
  /// The optional [index] parameter can be used to specify the color index in the favorites list.
  void toggle(ColorItem colorItem) {
    // index ??= indexOf(colorItem);
    // final int result;
    // if (index >= 0 && index < _list.length) {
    //   _list.removeAt(index);
    //   result = -1;
    // } else {
    //   _list.add(colorItem);
    //   result = _list.length - 1;
    // }

    if (_setOfFavorites.contains(colorItem)) {
      _setOfFavorites.remove(colorItem);
    } else {
      _setOfFavorites.add(colorItem);
    }

    onChanged?.call();
  }

  List<ColorItem> toList() {
    return _setOfFavorites.toList();
  }

  /// Returns a list of JSON string representations of the colors in this [ColorFavoritesList].
  List<String> toJsonStringList() {
    return _setOfFavorites.map((ColorItem color) => jsonEncode(color.toJson())).toList();
  }

  /// Returns a list of compact storage string representations of the favorite colors.
  List<String> toKeyList() {
    return _setOfFavorites.map((ColorItem colorItem) => colorItem.key).toList();
  }

  void loadFromKeyList(
    List<String>? keyList, {
    required Map<ColorType, RandomColorGenerator> generators,
  }) {
    if (keyList == null) return;

    _setOfFavorites.clear();
    for (final key in keyList) {
      final type = ColorType.fromPrefix(key[0]);
      if (type == null) continue;

      final hexString = key.substring(1);
      final color = color_utils.rgbHexToColor(hexString);

      final colorItem = generators[type]?.elementFrom(color!);
      if (colorItem != null) {
        _setOfFavorites.add(colorItem);
      }
    }
  }

  /// Loads the colors in this [ColorFavoritesList] from the given list of JSON string
  /// representations.
  void loadFromJsonStringList(List<String>? jsonStringList) {
    if (jsonStringList == null) return;

    _setOfFavorites.clear();
    _setOfFavorites.addAll(
      jsonStringList.map((String jsonString) => ColorItem.fromJson(jsonDecode(jsonString))),
    );
  }

  /// Returns a CSV string representation of this [ColorFavoritesList].
  String toCsvString() {
    final csvBuffer = StringBuffer();

    // Write the headers first
    csvBuffer.writeln('color,name,type');

    // Write the favorite colors
    for (final colorItem in _setOfFavorites) {
      csvBuffer.writeln(colorItem.toCsvString());
    }

    return csvBuffer.toString();
  }
}
