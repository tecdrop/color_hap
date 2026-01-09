// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// User interface strings for the ColorHap app.
library;

import '../models/color_type.dart';

// -----------------------------------------------------------------------------------------------
// App
// -----------------------------------------------------------------------------------------------

const appName = 'ColorHap';

// -----------------------------------------------------------------------------------------------
// Common
// -----------------------------------------------------------------------------------------------

String copiedSnack(String value) => '$value copied to clipboard';
String copiedErrorSnack(String value) => 'Copy to clipboard failed: $value';

const randomPrefix = 'Random';

const Map<ColorType, String> colorTypeSingular = {
  .mixedColor: 'Color',
  .basicColor: 'Basic Color',
  .webColor: 'Web Color',
  .namedColor: 'Named Color',
  .attractiveColor: 'Attractive Color',
  .trueColor: 'True Color',
};

String randomColorType(ColorType value) => 'Random ${colorTypeSingular[value]}';

const Map<ColorType, String> colorTypePlural = {
  .mixedColor: 'Colors',
  .basicColor: 'Basic Colors',
  .webColor: 'Web Colors',
  .namedColor: 'Named Colors',
  .attractiveColor: 'Attractive Colors',
  .trueColor: 'True Colors',
};

// -----------------------------------------------------------------------------------------------
// Drawer items
// -----------------------------------------------------------------------------------------------

const setWallpaperDrawer = 'Set a Color Wallpaper';
const setWallpaperDrawerSubtitle = 'Use RGB Color Wallpaper Pro\nand support our free apps!';

const randomMixedColorDrawer = 'Random Colors';
const randomBasicColorDrawer = 'Random Basic Colors';
const randomWebColorDrawer = 'Random Web Colors';
const randomNamedColorDrawer = 'Random Named Colors';
const randomAttractiveColorDrawer = 'Random Attractive Colors';
const randomTrueColorDrawer = 'Random True Colors';
String possibilitiesDrawerSubtitle(String length) => '$length possibilities';

const tweakColorDrawer = 'Tweak Color';
const colorInfoDrawer = 'Color Information';
const colorPreviewDrawer = 'Color Preview';
const availableColorsDrawer = 'Available Colors';
const colorFavoritesDrawer = 'Favorite Colors';
String colorFavoritesSubtitle(String length, {bool isPlural = true}) =>
    '$length color${isPlural ? 's' : ''}';

const helpDrawer = 'Help & Support';
const sourceCodeDrawer = 'Star on GitHub';
const sourceCodeDrawerSubtitle = 'Yes, it\'s open source!';
const rateAppDrawer = 'Rate App';

// -----------------------------------------------------------------------------------------------
// Random Color Screen (Home Screen)
// -----------------------------------------------------------------------------------------------

const initGeneratorsError = 'Error initializing color generators.';

const addFavTooltip = 'Add color to favorites';
const removeFavTooltip = 'Remove color from favorites';
const colorInfoTooltip = 'Color information';
const favoriteColorsAction = 'Favorite Colors';

const shuffleTooltip = 'Get a new random color';
const tweakColorTooltip = 'Tweak this color';

// -----------------------------------------------------------------------------------------------
// Tweak Color Screen
// -----------------------------------------------------------------------------------------------

const colorTweakScreenTitle = 'Tweak Color';

const applyColorAction = 'APPLY';
const editColorCodeAction = 'Edit color code';

// -----------------------------------------------------------------------------------------------
// Edit Color Screen
// -----------------------------------------------------------------------------------------------

const editColorScreenTitle = 'Edit Color Code';

const inputHexHint = 'RRGGBB';

// -----------------------------------------------------------------------------------------------
// Color Info Screen
// -----------------------------------------------------------------------------------------------

const colorInfoScreenTitle = 'Color Information';
const colorPreviewAction = 'Preview color';
const copyAllAction = 'Copy all';
const shareAllAction = 'Share all';
const colorWebSearchAction = 'More on the web';

const shareSwatchFAB = 'Share swatch';
String shareSwatchMessage(String colorTitle) =>
    '$colorTitle, a random color generated just for you with ColorHap 🎨 https://colorhap.tecdrop.com/';
const shareSwatchError = 'Failed to share color swatch';

const colorNameInfo = 'Name';
const colorTitleInfo = 'Name & Code';
const colorTypeInfo = 'Color type';
const hexInfo = 'Hex triplet';
const rgbInfo = 'RGB';
const hsvInfo = 'HSV';
const hslInfo = 'HSL';
const decimalInfo = 'Decimal';
const luminanceInfo = 'Luminance';
const brightnessInfo = 'Brightness';

const itemCopyTooltip = 'Copy value';
const itemShareTooltip = 'Share value';
const allInfoCopied = 'All color information copied to clipboard';
const shareItemError = 'Failed to share';
const shareAllError = 'Failed to share color information';

// -----------------------------------------------------------------------------------------------
// Favorite Colors Screen
// -----------------------------------------------------------------------------------------------

const favoriteColorsScreenTitle = 'Favorite Colors';
const noFavoritesMessage = 'No favorite colors yet\n\nGo back home and start tapping on';
const removedFromFavorites = 'Removed from favorites';
const undoRemoveFromFavorites = 'Undo';
const clearFavorites = 'Clear favorites';
const clearFavoritesDialogTitle = 'Clear favorites?';
const clearFavoritesDialogMessage = 'This will remove all colors from your favorites list.';
const clearFavoritesDialogPositiveAction = 'Clear';
const exportFavoritesAsCsv = 'Export favorites as CSV';
const loadScreenshotColors = 'Load Screenshot Colors';

// -----------------------------------------------------------------------------------------------
// Available Colors Screen
// -----------------------------------------------------------------------------------------------

String availableColors(ColorType value) => 'Available ${colorTypePlural[value]}';
const aboutTheseColorsTooltip = 'About these colors';

// -----------------------------------------------------------------------------
// Loading Screen
// -----------------------------------------------------------------------------

const loadingColorsMessage = 'Loading colors...';

// -----------------------------------------------------------------------------
// Error Screen
// -----------------------------------------------------------------------------

const errorScreenTitle = 'Error';
const retryButton = 'Retry';
