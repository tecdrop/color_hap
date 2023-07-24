// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import '../models/color_type.dart';

// -----------------------------------------------------------------------------------------------
// App
// -----------------------------------------------------------------------------------------------

const String appName = 'ColorHap';

// -----------------------------------------------------------------------------------------------
// Common
// -----------------------------------------------------------------------------------------------

String copiedSnack(String value) => '$value copied to clipboard';
String copiedErrorSnack(String value) => 'Copy to clipboard failed: $value';

const Map<ColorType, String> colorType = {
  ColorType.mixedColor: 'Random Color',
  ColorType.basicColor: 'Random Basic Color',
  ColorType.webColor: 'Random Web Color',
  ColorType.namedColor: 'Random Named Color',
  ColorType.attractiveColor: 'Random Attractive Color',
  ColorType.trueColor: 'Random True Color',
};

// -----------------------------------------------------------------------------------------------
// Drawer items
// -----------------------------------------------------------------------------------------------

const String setWallpaperDrawer = 'Set A Color Wallpaper';
const String setWallpaperDrawerSubtitle = 'Use RGB Color Wallpaper Pro\nand support our free apps!';

const String randomMixedColorDrawer = 'Random Colors';
const String randomBasicColorDrawer = 'Random Basic Colors';
const String randomWebColorDrawer = 'Random Web Colors';
const String randomNamedColorDrawer = 'Random Named Colors';
const String randomAttractiveColorDrawer = 'Random Attractive Colors';
const String randomAttractiveColorDrawerSubtitle = 'A few million possibilities';
const String randomTrueColorDrawer = 'Random True Colors';
String possibilitiesDrawerSubtitle(String length) => '$length possibilities';

const String colorInfoDrawer = 'Color Information';
const String colorFavoritesDrawer = 'Favorite Colors';

const String helpDrawer = 'Help & Support';
const String sourceCodeDrawer = 'View App Source';
const String rateAppDrawer = 'Rate App';

// -----------------------------------------------------------------------------------------------
// Color Info Screen
// -----------------------------------------------------------------------------------------------

const String colorInfoScreenTitle = 'Color Information';
const String toggleColorInformation = 'Toggle color information';
const String webSearchColor = 'Search color on the web';

const String colorNameInfo = 'Name';
const String colorTitleInfo = 'Name & Code';
const String colorTypeInfo = 'Color type';
const String hexInfo = 'Hex triplet';
const String rgbInfo = 'RGB';
const String hsvInfo = 'HSV';
const String hslInfo = 'HSL';
const String decimalInfo = 'Decimal';
const String luminanceInfo = 'Luminance';
const String brightnessInfo = 'Brightness';

// -----------------------------------------------------------------------------------------------
// Random Color Screen
// -----------------------------------------------------------------------------------------------

const String colorInfoTooltip = 'Color information';
const String addFavTooltip = 'Add color to favorites';
const String removeFavTooltip = 'Remove color from favorites';
const String shuffleTooltip = 'Get a new random color';

// -----------------------------------------------------------------------------------------------
// Invalid Color Screen
// -----------------------------------------------------------------------------------------------

String invalidColor(String? colorCode) => 'Invalid color code: $colorCode';

// -----------------------------------------------------------------------------------------------
// Favorite Colors Screen
// -----------------------------------------------------------------------------------------------

const String favoriteColorsScreenTitle = 'Favorite Colors';
const String noFavoritesMessage = 'No favorite colors yet';
const String removedFromFavorites = 'Removed from favorites';
const String undoRemoveFromFavorites = 'Undo';
const String clearFavorites = 'Clear favorites';
const String clearFavoritesDialogTitle = 'Clear favorites?';
const String clearFavoritesDialogMessage = 'This will remove all colors from your favorites list.';
const String clearFavoritesDialogPositiveAction = 'Clear';
const String exportFavoritesAsCsv = 'Export favorites as CSV';
const String favoritesExported = 'Favorites exported to clipboard in CSV format';
