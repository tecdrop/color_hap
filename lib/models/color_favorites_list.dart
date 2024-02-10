// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:color_hap/models/random_color.dart';

/// A list of favorite random colors.
class ColorFavoritesList {
  /// The list of [RandomColor] objects in the favorites list.
  final List<RandomColor> _list = <RandomColor>[];

  /// The number of colors in the favorites list.
  int get length => _list.length;

  /// Returns the index of the given [randomColor] in the favorites list, or -1 if it is not there.
  int indexOf(RandomColor randomColor) {
    return _list.indexOf(randomColor);
  }

  /// Returns the color at the given [index] in the favorites list.
  RandomColor elementAt(int index) => _list.elementAt(index);

  /// Inserts the given [randomColor] at the given [index] in the favorites list.
  void insert(int index, RandomColor randomColor) {
    _list.insert(index, randomColor);
  }

  /// Removes the color at the given [index] from the favorites list.
  RandomColor removeAt(int index) => _list.removeAt(index);

  /// Clears the favorites list.
  void clear() => _list.clear();

  /// Removes the given [randomColor] from the favorites list if it is already there, or adds it to
  /// the list if it is not.
  ///
  /// Returns the index of the color in the favorites list if it was added, or -1 if it was removed.
  /// The optional [index] parameter can be used to specify the color index in the favorites list.
  int toggle(RandomColor randomColor, {int? index}) {
    index ??= indexOf(randomColor);
    if (index >= 0 && index < _list.length) {
      _list.removeAt(index);
      return -1;
    } else {
      _list.add(randomColor);
      return _list.length - 1;
    }
  }

  /// Returns a list of JSON string representations of the colors in this [ColorFavoritesList].
  List<String> toJsonStringList() {
    return _list.map((RandomColor color) => jsonEncode(color.toJson())).toList();
  }

  /// Loads the colors in this [ColorFavoritesList] from the given list of JSON string
  /// representations.
  void loadFromJsonStringList(List<String>? jsonStringList) {
    if (jsonStringList == null) return;

    _list.clear();
    _list.addAll(
      jsonStringList.map((String jsonString) => RandomColor.fromJson(jsonDecode(jsonString))),
    );
  }

  /// Returns a CSV string representation of this [ColorFavoritesList].
  String toCsvString() {
    final StringBuffer csvBuffer = StringBuffer();

    // Write the headers first
    csvBuffer.writeln('color,name,type');

    // Write the favorite colors
    for (final RandomColor color in _list) {
      csvBuffer.writeln(color.toCsvString());
    }

    return csvBuffer.toString();
  }
}
