// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

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

const Map<ColorType, String> colorTypePlural = {
  ColorType.mixedColor: 'Colors',
  ColorType.basicColor: 'Basic Colors',
  ColorType.webColor: 'Web Colors',
  ColorType.namedColor: 'Named Colors',
  ColorType.attractiveColor: 'Attractive Colors',
  ColorType.trueColor: 'True Colors',
};

String availableColors(ColorType value) => 'Available ${colorTypePlural[value]}';

// -----------------------------------------------------------------------------------------------
// Drawer items
// -----------------------------------------------------------------------------------------------

const String setWallpaperDrawer = 'Set a Color Wallpaper';
const String setWallpaperDrawerSubtitle = 'Use RGB Color Wallpaper Pro\nand support our free apps!';

const String randomMixedColorDrawer = 'Random Colors';
const String randomBasicColorDrawer = 'Random Basic Colors';
const String randomWebColorDrawer = 'Random Web Colors';
const String randomNamedColorDrawer = 'Random Named Colors';
const String randomAttractiveColorDrawer = 'Random Attractive Colors';
const String randomTrueColorDrawer = 'Random True Colors';
String possibilitiesDrawerSubtitle(String length) => '$length possibilities';
const String colorReferenceDrawer = 'Color Reference';

const String colorInfoDrawer = 'Color Information';
const String colorPreviewDrawer = 'Color Preview';
const String colorFavoritesDrawer = 'Favorite Colors';
String colorFavoritesSubtitle(String length, {bool isPlural = true}) =>
    '$length color${isPlural ? 's' : ''}';

const String helpDrawer = 'Help & Support';
const String sourceCodeDrawer = 'Star on GitHub';
const String sourceCodeDrawerSubtitle = 'Yes, it\'s open source!';
const String rateAppDrawer = 'Rate App';

// -----------------------------------------------------------------------------------------------
// Random Color Screen (Home Screen)
// -----------------------------------------------------------------------------------------------

const String addFavTooltip = 'Add color to favorites';
const String removeFavTooltip = 'Remove color from favorites';
const String colorInfoTooltip = 'Color information';
const String colorPreviewMenuItem = 'Color Preview';
const String shuffleTooltip = 'Get a new random color';

// -----------------------------------------------------------------------------------------------
// Color Info Screen
// -----------------------------------------------------------------------------------------------

const String colorInfoScreenTitle = 'Color Information';
const String colorPreviewAction = 'Preview color';
const String copyAllAction = 'Copy all';
const String shareAllAction = 'Share all';
const String colorWebSearchAction = 'More on the web';

const String shareSwatchFAB = 'Share swatch';
String shareSwatchMessage(String colorTitle) =>
    '$colorTitle, a random color generated just for you with ColorHap 🎨 https://colorhap.tecdrop.com/';

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

const String itemCopyTooltip = 'Copy value';
const String itemShareTooltip = 'Share value';
const String allInfoCopied = 'All color information copied to clipboard';

// -----------------------------------------------------------------------------------------------
// Favorite Colors Screen
// -----------------------------------------------------------------------------------------------

const String favoriteColorsScreenTitle = 'Favorite Colors';
const String noFavoritesMessage = 'No favorite colors yet\n\nGo back home and start tapping on';
const String removedFromFavorites = 'Removed from favorites';
const String undoRemoveFromFavorites = 'Undo';
const String clearFavorites = 'Clear favorites';
const String clearFavoritesDialogTitle = 'Clear favorites?';
const String clearFavoritesDialogMessage = 'This will remove all colors from your favorites list.';
const String clearFavoritesDialogPositiveAction = 'Clear';
const String exportFavoritesAsCsv = 'Export favorites as CSV';
const String favoritesExported = 'Favorites exported to clipboard in CSV format';

// -----------------------------------------------------------------------------------------------
// Available Colors Screen
// -----------------------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------------------
// Available Mixed Colors Screen
// -----------------------------------------------------------------------------------------------

const String availableMixedColorScreenTitle = 'Available Colors';
