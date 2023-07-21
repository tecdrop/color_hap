// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import '../models/color_type.dart';

/// User interface strings.
class UIStrings {
  UIStrings._();

  // -----------------------------------------------------------------------------------------------
  // App
  // -----------------------------------------------------------------------------------------------

  static const String appName = 'ColorHap';

  // -----------------------------------------------------------------------------------------------
  // Common
  // -----------------------------------------------------------------------------------------------

  static String copiedSnack(String value) => '$value copied to clipboard';
  static String copiedErrorSnack(String value) => 'Copy to clipboard failed: $value';

  static const Map<ColorType, String> colorType = {
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

  static const String setWallpaperDrawer = 'Set A Color Wallpaper';
  static const String setWallpaperDrawerSubtitle =
      'Use RGB Color Wallpaper Pro\nand support our free apps!';

  static const String randomMixedColorDrawer = 'Random Colors';
  static const String randomBasicColorDrawer = 'Random Basic Colors';
  static const String randomWebColorDrawer = 'Random Web Colors';
  static const String randomNamedColorDrawer = 'Random Named Colors';
  static const String randomAttractiveColorDrawer = 'Random Attractive Colors';
  static const String randomAttractiveColorDrawerSubtitle = 'A few million possibilities';
  static const String randomTrueColorDrawer = 'Random True Colors';
  static String possibilitiesDrawerSubtitle(String length) => '$length possibilities';

  static const String colorDetailsDrawer = 'Color Details';
  static const String colorInfoDrawer = 'Color Information';
  static const String previewColorDrawer = 'Preview Color';
  static const String colorFavoritesDrawer = 'Favorite Colors';

  static const String helpDrawer = 'Help & Support';
  static const String sourceCodeDrawer = 'View App Source';
  static const String rateAppDrawer = 'Rate App';

  // -----------------------------------------------------------------------------------------------
  // Random Color Screen
  // -----------------------------------------------------------------------------------------------

  static const String colorInfoTooltip = 'Color information';
  static const String addFavTooltip = 'Add this random color to favorites';
  static const String removeFavTooltip = 'Remove this random color from favorites';
  static const String toggleImmersiveTooltip = 'Toggle immersive mode';
  static const String shuffleTooltip = 'Get a new random color';

  // -----------------------------------------------------------------------------------------------
  // Color Info Screen
  // -----------------------------------------------------------------------------------------------

  static const String colorInfoScreenTitle = 'Color Information';

  static const String colorNameInfo = 'Name';
  static const String colorTitleInfo = 'Name & Code';
  static const String colorTypeInfo = 'Color type';
  static const String hexInfo = 'Hex triplet';
  static const String rgbInfo = 'RGB';
  static const String hsvInfo = 'HSV';
  static const String hslInfo = 'HSL';
  static const String decimalInfo = 'Decimal';
  static const String luminanceInfo = 'Luminance';
  static const String brightnessInfo = 'Brightness';

  static const String copyTooltip = 'Copy current info to clipboard';
  static const String shareTooltip = 'Share current info';
  static const String searchTooltip = 'Search the current info on the Internet';

  // -----------------------------------------------------------------------------------------------
  // Invalid Color Screen
  // -----------------------------------------------------------------------------------------------

  static String invalidColor(String? colorCode) => 'Invalid color code: $colorCode';
}
