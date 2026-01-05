// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'color_item.dart';

/// A list of favorite random colors.
class ColorFavoritesList {
  ColorFavoritesList({this.onChanged});

  /// Callback invoked whenever the list is modified.
  final VoidCallback? onChanged;

  /// The list of [ColorItem] objects in the favorites list.
  final List<ColorItem> _list = <ColorItem>[];

  /// The number of colors in the favorites list.
  int get length => _list.length;

  /// Returns the index of the given [colorItem] in the favorites list, or -1 if it is not there.
  int indexOf(ColorItem colorItem) {
    return _list.indexOf(colorItem);
  }

  /// Returns the color at the given [index] in the favorites list.
  ColorItem elementAt(int index) => _list.elementAt(index);

  /// Inserts the given [ColorItem] at the given [index] in the favorites list.
  void insert(int index, ColorItem colorItem) {
    _list.insert(index, colorItem);
    onChanged?.call();
  }

  /// Removes the color at the given [index] from the favorites list.
  ColorItem removeAt(int index) {
    final result = _list.removeAt(index);
    onChanged?.call();
    return result;
  }

  /// Clears the favorites list.
  void clear() {
    _list.clear();
    onChanged?.call();
  }

  /// Removes the given [colorItem] from the favorites list if it is already there, or adds it to
  /// the list if it is not.
  ///
  /// Returns the index of the color in the favorites list if it was added, or -1 if it was removed.
  /// The optional [index] parameter can be used to specify the color index in the favorites list.
  int toggle(ColorItem colorItem, {int? index}) {
    index ??= indexOf(colorItem);
    final int result;
    if (index >= 0 && index < _list.length) {
      _list.removeAt(index);
      result = -1;
    } else {
      _list.add(colorItem);
      result = _list.length - 1;
    }
    onChanged?.call();
    return result;
  }

  /// Returns a list of JSON string representations of the colors in this [ColorFavoritesList].
  List<String> toJsonStringList() {
    return _list.map((ColorItem color) => jsonEncode(color.toJson())).toList();
  }

  /// Loads the colors in this [ColorFavoritesList] from the given list of JSON string
  /// representations.
  void loadFromJsonStringList(List<String>? jsonStringList) {
    if (jsonStringList == null) return;

    _list.clear();
    _list.addAll(
      jsonStringList.map((String jsonString) => ColorItem.fromJson(jsonDecode(jsonString))),
    );
  }

  /// Returns a CSV string representation of this [ColorFavoritesList].
  String toCsvString() {
    final csvBuffer = StringBuffer();

    // Write the headers first
    csvBuffer.writeln('color,name,type');

    // Write the favorite colors
    for (final colorItem in _list) {
      csvBuffer.writeln(colorItem.toCsvString());
    }

    return csvBuffer.toString();
  }
}
