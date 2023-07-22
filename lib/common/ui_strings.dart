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

const String colorDetailsDrawer = 'Color Details';
const String colorFavoritesDrawer = 'Favorite Colors';

const String helpDrawer = 'Help & Support';
const String sourceCodeDrawer = 'View App Source';
const String rateAppDrawer = 'Rate App';

// -----------------------------------------------------------------------------------------------
// Color Details Screen
// -----------------------------------------------------------------------------------------------

const String colorDetailsScreenTitle = 'Color Details';
const String toggleColorInformation = 'Toggle color information';

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
const String addFavTooltip = 'Add this random color to favorites';
const String removeFavTooltip = 'Remove this random color from favorites';
const String shuffleTooltip = 'Get a new random color';

// -----------------------------------------------------------------------------------------------
// Invalid Color Screen
// -----------------------------------------------------------------------------------------------

String invalidColor(String? colorCode) => 'Invalid color code: $colorCode';
