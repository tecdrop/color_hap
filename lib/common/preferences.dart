// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:shared_preferences/shared_preferences.dart';

import '../models/color_favorites_list.dart';
import '../models/color_type.dart';

// -----------------------------------------------------------------------------------------------
// colorType setting
// -----------------------------------------------------------------------------------------------

const String _colorTypeKey = 'colorType';

/// The last type of random colors generated by the user.
ColorType _colorType = ColorType.webColor;
ColorType get colorType => _colorType;
set colorType(ColorType value) {
  _colorType = value;
  _saveColorType();
}

/// Saves the color type setting to persistent storage.
Future<void> _saveColorType() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setInt(_colorTypeKey, _colorType.index);
}

// -----------------------------------------------------------------------------------------------
// favList setting
// -----------------------------------------------------------------------------------------------

const String _colorFavoritesListKey = 'colorFavoritesList';

/// The list of favorite colors.
ColorFavoritesList colorFavoritesList = ColorFavoritesList();

/// Saves the favorite colors list to persistent storage.
///
/// This should be called whenever the list of favorite colors changes (add, remove, clear, etc.)
Future<void> saveColorFavoritesList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setStringList(_colorFavoritesListKey, colorFavoritesList.toJsonStringList());
}

// -----------------------------------------------------------------------------------------------
// Common
// -----------------------------------------------------------------------------------------------

/// Loads app settings from persistent storage.
Future<void> loadSettings() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  // Load the last color type used by the user
  _colorType = ColorType.values[preferences.getInt(_colorTypeKey) ?? 0];

  // Load the list of favorite colors
  colorFavoritesList.loadFromJsonStringList(preferences.getStringList(_colorFavoritesListKey));
}
