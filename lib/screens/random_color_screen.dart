// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../../common/urls.dart' as urls;
import '../common/preferences.dart' as preferences;
import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../services/generators_initializer.dart';
import '../utils/utils.dart' as utils;
import '../widgets/internal/app_drawer.dart';
import '../widgets/long_app_bar_title.dart';
import '../widgets/random_color_display.dart';
import 'available_colors_screen.dart';
import 'color_favorites_screen.dart';
import 'color_info_screen.dart';
import 'color_preview_screen.dart';
import 'color_tweak_screen.dart';
import 'error_screen.dart';
import 'loading_screen.dart';

/// The Random Color screen, that is the home screen of the app.
///
/// It displays the current random color, and lets the user to generate new random colors.
class RandomColorScreen extends StatefulWidget {
  const RandomColorScreen({super.key});

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  /// Whether the color lists and generators are still loading.
  bool _isLoading = true;

  /// The error message if loading failed.
  String? _loadingError;

  /// A map with singleton random color generators for each color type.
  late Map<ColorType, RandomColorGenerator> _generators;

  /// The random number generator used for generating random colors.
  final Random _random = Random();

  /// The type of colors to generate.
  late ColorType _colorType;

  // The current random color.
  // Initialized with a default black true color value to avoid null checks.
  ColorItem _randomColor = const ColorItem(
    type: .trueColor,
    color: Colors.black,
    listPosition: 0,
  );

  // The index of the current color in the favorites list.
  int _colorFavIndex = -1;

  /// A map with the number of possible random colors for each color type.
  late Map<ColorType, int> _possibilityCount;

  /// Loads all color lists from assets and initializes singleton generators
  Future<void> _initAllGenerators() async {
    try {
      _generators = await initAllGenerators();

      // Await a short delay to show the loading screen
      // await Future<void>.delayed(const Duration(milliseconds: 1000));

      // throw some exception for testing
      // throw Exception(
      //   'Test exception with a long message to see how it is displayed in the error screen.',
      // );

      // Compute the number of possible random colors for each color type
      _possibilityCount = _generators.map(
        (ColorType type, RandomColorGenerator generator) =>
            MapEntry<ColorType, int>(type, generator.length),
      );

      // Done loading
      _isLoading = false;

      // Generate the first random color - this also updates state
      _shuffleColor();
    } on Exception catch (e) {
      // Handle loading errors
      if (kDebugMode) debugPrint('Failed to initialize color generators: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingError = '${strings.initGeneratorsError} ${e.toString()}';
        });
      }
    }
  }

  /// Retries loading color lists and generators
  Future<void> _retryLoading() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingError = null;
      });
    }
    await _initAllGenerators();
  }

  @override
  void initState() {
    super.initState();

    // Start color list loading (cached for subsequent uses)
    _initAllGenerators();

    // Restore the last selected color type
    _colorType = preferences.colorType;
  }

  void _updateState(ColorItem? randomColor) {
    setState(() {
      if (randomColor != null) _randomColor = randomColor;
      _colorFavIndex = preferences.colorFavoritesList.indexOf(_randomColor);
    });
  }

  /// Navigates to the Color Info screen with the current color.
  void _gotoColorInfoScreen() {
    utils.navigateTo(context, ColorInfoScreen(colorItem: _randomColor));
  }

  /// Navigates to the Color Preview screen with the current color.
  void _gotoColorPreviewScreen() {
    utils.navigateTo(context, ColorPreviewScreen(color: _randomColor.color));
  }

  /// Navigates to the Available Colors screen for the selected color type.
  void _gotoAvailableColorsScreen() async {
    // Get the generator for the type of the current random color
    final curColorGenerator = _generators[_randomColor.type]!;

    // Navigate to the Available Colors screen for the current color type, passing the current
    // random color as the initial selected color
    final randomColor = await utils.navigateTo<ColorItem>(
      context,
      AvailableColorsScreen(generator: curColorGenerator, initialColor: _randomColor),
    );

    // Update the current random color if a new color was selected
    _updateState(randomColor);
  }

  /// Navigates to the Color Tweak screen for the current color.
  void _gotoColorTweakScreen() async {
    final tweakedColor = await utils.navigateTo<ColorItem>(
      context,
      ColorTweakScreen(initialColor: _randomColor.color),
    );

    // Update the current random color if a color was tweaked
    _updateState(tweakedColor);
  }

  /// Navigates to the Available Colors screen for the selected color type.
  void _gotoColorFavoritesScreen() async {
    final randomColor = await utils.navigateTo<ColorItem>(
      context,
      const ColorFavoritesScreen(),
    );

    // Update the current color type of the screen to match the type of the selected favorite color
    if (randomColor != null) _colorType = randomColor.type;

    // Update the current random color if a new color was selected; otherwise, update the state to
    // refresh the favorite icon, maybe the current color was removed from the favorites list
    _updateState(randomColor);
  }

  /// Performs the actions of the app bar.
  void _onAction(_AppBarActions action) async {
    switch (action) {
      // Toggle the current color in the favorites list
      case .toggleFavorite:
        setState(() {
          _colorFavIndex = preferences.colorFavoritesList.toggle(
            _randomColor,
            index: _colorFavIndex,
          );
        });
        break;

      // Open the Color Information screen with the current color
      case .colorInfo:
        _gotoColorInfoScreen();
        break;

      // Open the Available Colors screen
      case .availableColors:
        _gotoAvailableColorsScreen();
        break;

      // Open the Color Favorites screen
      case .favoriteColors:
        _gotoColorFavoritesScreen();
        break;
    }
  }

  /// Generates a new random color.
  void _shuffleColor() {
    final randomColor = _generators[_colorType]!.next(_random);
    _updateState(randomColor);
  }

  /// Copies the current color hex code and name (if available) to the clipboard.
  Future<void> copyColor() async {
    await utils.copyToClipboard(context, _randomColor.longTitle);
  }

  void changeColorType(ColorType colorType) {
    preferences.colorType = _colorType = colorType;
    _shuffleColor();
  }

  /// Starts a specific functionality of the app when the user taps a drawer [item].
  void _onDrawerItemTap(AppDrawerItems item) {
    Navigator.pop(context); // First, close the drawer

    switch (item) {
      // Launch the external RGB Color Wallpaper Pro url
      case .setWallpaper:
        utils.launchUrlExternal(context, urls.setWallpaper);
        break;

      // Reopen the Random Color screen for generating random colors (of any type)
      case .randomMixedColor:
        changeColorType(.mixedColor);
        break;

      // Reopen the Random Color screen for generating random basic colors
      case .randomBasicColor:
        changeColorType(.basicColor);
        break;

      // Reopen the Random Color screen for generating random web colors
      case .randomWebColor:
        changeColorType(.webColor);
        break;

      // Reopen the Random Color screen for generating random named colors
      case .randomNamedColor:
        changeColorType(.namedColor);
        break;

      // Reopen the Random Color screen for generating random attractive colors
      case .randomAttractiveColor:
        changeColorType(.attractiveColor);
        break;

      // Reopen the Random Color screen for generating random true colors
      case .randomTrueColor:
        changeColorType(.trueColor);
        break;

      // Open the Color Info screen with the current random color
      case .colorInfo:
        _gotoColorInfoScreen();
        break;

      // Open the Color Preview screen with the current random color
      case .colorPreview:
        _gotoColorPreviewScreen();
        break;

      // Open the Color Tweak screen for the current color
      case .tweakColor:
        _gotoColorTweakScreen();
        break;

      // Open the Available Colors screen
      case .availableColors:
        _gotoAvailableColorsScreen();
        break;

      // Open the Color Favorites screen
      case .favoriteColors:
        _gotoColorFavoritesScreen();
        break;

      // Launch the external Online Help url
      case .help:
        utils.launchUrlExternal(context, urls.help);
        break;

      // Launch the external View Source url
      case .viewSource:
        utils.launchUrlExternal(context, urls.viewSource);
        break;

      // Launch the external Rate App url
      case .rateApp:
        utils.launchUrlExternal(context, urls.getRateUrl());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen(message: strings.loadingColorsMessage);
    }

    if (_loadingError != null) {
      return ErrorScreen(
        message: _loadingError!,
        onRetry: _retryLoading,
      );
    }

    return Scaffold(
      // The app bar
      appBar: _AppBar(
        actualColorType: _randomColor.type,
        isFavorite: _colorFavIndex >= 0,
        onAction: _onAction,
      ),

      // The app drawer
      drawer: AppDrawer(
        colorItem: _randomColor,
        colorType: _colorType,
        possibilityCount: _possibilityCount,
        onItemTap: _onDrawerItemTap,
      ),

      // A simple body with the centered color display
      body: Center(
        child: RandomColorDisplay(
          colorItem: _randomColor,
          // Navigate to the Color Preview screen when the user double-taps the color code/name
          onDoubleTap: () => _gotoColorPreviewScreen(),
          // Copy the color hex code/name to the clipboard when the user long-presses it
          onLongPress: copyColor,
        ),
      ),

      // The floating action buttons
      floatingActionButton: _Fabs(
        onShuffle: _shuffleColor,
        onTweak: _gotoColorTweakScreen,
      ),
    );
  }
}

/// The floating action buttons of the Random Color screen.
class _Fabs extends StatelessWidget {
  const _Fabs({
    super.key, // ignore: unused_element_parameter
    required this.onShuffle,
    required this.onTweak,
  });

  /// Callback invoked when the shuffle FAB is pressed.
  final void Function() onShuffle;

  /// Callback invoked when the tweak FAB is pressed.
  final void Function() onTweak;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        // Mini tweak FAB
        FloatingActionButton(
          heroTag: 'tweakFab',
          onPressed: onTweak,
          tooltip: strings.tweakColorTooltip,
          child: const Icon(Icons.tune),
        ),

        const SizedBox(height: 16.0),

        // Large shuffle FAB
        FloatingActionButton.large(
          heroTag: 'shuffleFab',
          onPressed: onShuffle,
          tooltip: strings.shuffleTooltip,
          child: const Icon(Icons.shuffle),
        ),
      ],
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions { toggleFavorite, colorInfo, availableColors, favoriteColors }

/// The app bar of the Random Color screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element_parameter
    required this.actualColorType,
    required this.isFavorite,
    required this.onAction,
  });

  /// The actual type of the current color.
  final ColorType actualColorType;

  /// Whether the current color is added to the favorites list.
  final bool isFavorite;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: LongAppBarTitle(
        row1: strings.randomPrefix,
        row2: strings.colorTypeSingular[actualColorType]!,
      ),

      // The common operations displayed in this app bar
      actions: <Widget>[
        // The Favorite toggle icon button
        IconButton(
          icon: isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          tooltip: isFavorite ? strings.removeFavTooltip : strings.addFavTooltip,
          onPressed: () => onAction(.toggleFavorite),
        ),

        // The Color Information icon button
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: strings.colorInfoTooltip,
          onPressed: () => onAction(.colorInfo),
        ),

        // Add the overflow menu
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // Add the Available Colors action to the overflow menu
            PopupMenuItem<_AppBarActions>(
              value: .availableColors,
              child: Text(strings.availableColors(actualColorType)),
            ),

            // Add the Favorites action to the overflow menu
            const PopupMenuItem<_AppBarActions>(
              value: .favoriteColors,
              child: Text(strings.favoriteColorsAction),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
