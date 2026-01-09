// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../utils/color_utils.dart' as color_utils;
import 'color_item.dart';
import 'color_type.dart';
import 'random_color_generator.dart';

/// The result of toggling a color in the favorites list.
enum ToggleResult {
  added,
  removed,
  noOp,
}

/// A list of favorite random colors.
class ColorFavoritesList {
  ColorFavoritesList({
    this.onChanged,
  });

  /// Callback invoked whenever the list is modified.
  final VoidCallback? onChanged;

  /// The set of [ColorItem] objects in the favorites list.
  final _setOfFavorites = <ColorItem>{};

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

  /// Clears the favorites list.
  void clear() {
    _setOfFavorites.clear();
    onChanged?.call();
  }

  /// Removes the given [colorItem] from the favorites list if it is already there, or adds it to
  /// the list if it is not.
  ///
  /// Returns a [ToggleResult] indicating whether the color was added, removed, or if no operation
  /// was performed (because the color was already in the desired state).
  ToggleResult toggle(ColorItem colorItem) {
    var result = ToggleResult.noOp;

    if (_setOfFavorites.contains(colorItem)) {
      result = _setOfFavorites.remove(colorItem) ? ToggleResult.removed : ToggleResult.noOp;
    } else {
      result = _setOfFavorites.add(colorItem) ? ToggleResult.added : ToggleResult.noOp;
    }

    onChanged?.call();
    return result;
  }

  List<ColorItem> toList() {
    return _setOfFavorites.toList();
  }

  /// Returns a list of compact storage string representations of the favorite colors.
  List<String> toKeyList() {
    return _setOfFavorites.map((ColorItem colorItem) => colorItem.key).toList();
  }

  /// Loads the colors in this [ColorFavoritesList] from the given list of compact storage string
  /// representations.
  void loadFromKeyList(
    List<String>? keyList, {
    required Map<ColorType, RandomColorGenerator> generators,
  }) {
    if (keyList == null) return;

    // First clear the existing favorites
    _setOfFavorites.clear();

    // Parse each key and reconstruct the ColorItem
    for (final key in keyList) {
      if (key.isEmpty) {
        if (kDebugMode) debugPrint('Invalid color favorite key: $key (empty string)');
        continue;
      }

      // First extract the color type from the key prefix
      final type = ColorType.fromPrefix(key[0]);
      if (type == null) {
        if (kDebugMode) debugPrint('Invalid color favorite key: $key (unknown type prefix)');
        continue;
      }

      // Then extract the hex string and convert to Color
      final hexString = key.substring(1);
      final color = color_utils.rgbHexToColor(hexString);
      if (color == null) {
        if (kDebugMode) debugPrint('Invalid color favorite key: $key (invalid hex string)');
        continue;
      }

      // Finally, find the corresponding ColorItem from the generator and add it to the favorites
      final colorItem = generators[type]?.elementFrom(color);
      if (colorItem != null) {
        _setOfFavorites.add(colorItem);
      } else {
        // Color not found in its original catalog - fallback to True Color to prevent data loss
        final trueColorItem = generators[ColorType.trueColor]?.elementFrom(color);
        if (trueColorItem != null) {
          _setOfFavorites.add(trueColorItem);
          if (kDebugMode) {
            debugPrint(
              'Migrated missing ${type.name} favorite to True Color: ${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
            );
          }
        }
      }
    }
  }

  /// Loads the favorites list from the given list of JSON string representations.
  @Deprecated('Use loadFromKeyList() instead. This is only for migration.')
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
