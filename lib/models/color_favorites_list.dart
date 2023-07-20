// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:color_hap/models/random_color.dart';

class ColorFavoritesList {
  final List<RandomColor> _favList = <RandomColor>[];

  /// The number of colors in the favorites list.
  int get length => _favList.length;

  /// Returns the index of the given [randomColor] in the favorites list, or -1 if it is not there.
  int indexOf(RandomColor randomColor) {
    return _favList.indexOf(randomColor);
  }

  /// Returns the color at the given [index] in the favorites list.
  RandomColor elementAt(int index) => _favList.elementAt(index);

  /// Removes the given [randomColor] from the favorites list if it is already there, or adds it to
  /// the list if it is not.
  ///
  /// Returns the index of the color in the favorites list if it was added, or -1 if it was removed.
  /// The optional [index] parameter can be used to specify the color index in the favorites list.
  int toggle(RandomColor randomColor, {int? index}) {
    index ??= indexOf(randomColor);
    if (index >= 0) {
      _favList.removeAt(index);
      return -1;
    } else {
      _favList.add(randomColor);
      return _favList.length - 1;
    }
  }
}
