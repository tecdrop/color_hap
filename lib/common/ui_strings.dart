// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import '../models/random_color.dart';

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
    ColorType.webColor: 'Random Web Color',
    ColorType.namedColor: 'Random Named Color',
    ColorType.attractiveColor: 'Random Attractive Color',
    ColorType.trueColor: 'Random True Color',
  };

  // -----------------------------------------------------------------------------------------------
  // Drawer items
  // -----------------------------------------------------------------------------------------------

  static const String randomWebColorDrawer = 'Random Web Colors';
  static const String randomNamedColorDrawer = 'Random Named Colors';
  static const String randomAttractiveColorDrawer = 'Random Attractive Colors';
  static const String randomAttractiveColorDrawerSubtitle = 'A few million possibilities';
  static const String randomTrueColorDrawer = 'Random True Colors';
  static String possibilitiesDrawerSubtitle(String length) => '$length possibilities';

  static const String colorInfoDrawer = 'Color Information';
  static const String setWallpaperDrawer = 'Set Color Wallpaper';
  static const String setWallpaperDrawerSubtitle = 'Using RGB Color Wallpaper Pro';

  static const String supportDrawer = 'Support';
  static const String rateAppDrawer = 'Rate App';
  static const String helpDrawer = 'Online Help';

  static const String viewSourceDrawer = 'View App Source';
  static const String viewSourceDrawerSubtitle = 'Yes, $appName is open source!';

  // -----------------------------------------------------------------------------------------------
  // Random Color Screen
  // -----------------------------------------------------------------------------------------------

  static const String colorInfoTooltip = 'Color information';
  static const String fullScreenTooltip = 'Toggle full screen';
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
}
