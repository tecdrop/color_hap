// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:color_hap/models/random_color.dart';

class ColorFavoritesList {
  final List<RandomColor> _list = <RandomColor>[];

  /// The number of colors in the favorites list.
  int get length => _list.length;

  /// Returns the index of the given [randomColor] in the favorites list, or -1 if it is not there.
  int indexOf(RandomColor randomColor) {
    return _list.indexOf(randomColor);
  }

  /// Returns the color at the given [index] in the favorites list.
  RandomColor elementAt(int index) => _list.elementAt(index);

  /// Removes the color at the given [index] from the favorites list.
  RandomColor removeAt(int index) => _list.removeAt(index);

  /// Removes the given [randomColor] from the favorites list if it is already there, or adds it to
  /// the list if it is not.
  ///
  /// Returns the index of the color in the favorites list if it was added, or -1 if it was removed.
  /// The optional [index] parameter can be used to specify the color index in the favorites list.
  int toggle(RandomColor randomColor, {int? index}) {
    index ??= indexOf(randomColor);
    if (index >= 0) {
      _list.removeAt(index);
      return -1;
    } else {
      _list.add(randomColor);
      return _list.length - 1;
    }
  }

  List<String> toJsonStringList() {
    return _list.map((RandomColor color) => jsonEncode(color.toJson())).toList();
  }

  void loadFromJsonStringList(List<String>? jsonStringList) {
    if (jsonStringList == null) return;

    _list.clear();
    _list.addAll(
      jsonStringList.map((String jsonString) => RandomColor.fromJson(jsonDecode(jsonString))),
    );
  }
}
