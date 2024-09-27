// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/app_const.dart' as consts;
import '../common/app_settings.dart' as settings;
import '../common/ui_strings.dart' as strings;
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../models/random_color.dart';
import '../utils/utils.dart' as utils;
import '../widgets/internal/app_drawer.dart';
import '../widgets/random_color_display.dart';
import 'available_colors_screen.dart';
import 'color_info_screen.dart';
import 'color_preview_screen.dart';

/// The Random Color screen, that is the home screen of the app.
///
/// It displays the current random color, and lets the user to generate new random colors.
class RandomColorScreen extends StatefulWidget {
  const RandomColorScreen({
    super.key,
  });

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  /// The type of colors to generate.
  late ColorType _colorType;

  // The current random color.
  // Initialized with a default black true color value to avoid null checks.
  RandomColor _randomColor = const RandomColor(
    type: ColorType.trueColor,
    color: Colors.black,
    listPosition: 0,
  );

  // The index of the current color in the favorites list.
  int _colorFavIndex = -1;

  @override
  void initState() {
    super.initState();

    // Restore the last selected color type
    _colorType = settings.colorType;

    // Generate the first random color
    _shuffleColor();
  }

  /// Performs the actions of the app bar.
  void _onAction(_AppBarActions action) async {
    switch (action) {
      // Toggle the current color in the favorites list
      case _AppBarActions.toggleFav:
        setState(() {
          _colorFavIndex = settings.colorFavoritesList.toggle(_randomColor, index: _colorFavIndex);
          settings.saveColorFavoritesList();
        });
        break;

      // Open the Color Information screen with the current color
      case _AppBarActions.colorInfo:
        utils.navigateTo(context, ColorInfoScreen(randomColor: _randomColor));
        break;

      // Open the Color Preview screen with the current color
      case _AppBarActions.colorPreview:
        utils.navigateTo(context, ColorPreviewScreen(color: _randomColor.color));
        break;

      // Open the Available Colors screen
      case _AppBarActions.availableColors:
        final double itemOffset = (_randomColor.listPosition ?? 0) * consts.colorListItemExtent;
        final ScrollController scrollController = ScrollController(
          initialScrollOffset: itemOffset,
          keepScrollOffset: false,
        );
        final RandomColor? randomColor = await utils.navigateTo<RandomColor>(
          context,
          AvailableColorsScreen(
            colorType: _colorType,
            scrollController: scrollController,
          ),
        );
        scrollController.dispose();
        if (randomColor != null) {
          setState(() {
            _randomColor = randomColor;
            _colorFavIndex = settings.colorFavoritesList.indexOf(_randomColor);
          });
        }
        break;
    }
  }

  /// Generates a new random color.
  void _shuffleColor() {
    final RandomColor randomColor = nextRandomColor(_colorType);
    _colorFavIndex = settings.colorFavoritesList.indexOf(randomColor);
    setState(() {
      _randomColor = randomColor;
    });
  }

  /// Copies the current color hex code and name (if available) to the clipboard.
  Future<void> copyColor() async {
    await utils.copyToClipboard(context, _randomColor.longTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar
      appBar: _AppBar(
        colorType: _colorType,
        isFavorite: _colorFavIndex >= 0,
        onAction: _onAction,
      ),

      // The app drawer
      drawer: AppDrawer(
        randomColor: _randomColor,
        colorType: _colorType,
        onColorTypeChange: (ColorType colorType) {
          settings.colorType = _colorType = colorType;
          _shuffleColor();
        },
        onShouldUpdateState: () => setState(() {
          _colorFavIndex = settings.colorFavoritesList.indexOf(_randomColor);
        }),
        onNextIdentityColor: () {
          setState(() {
            _randomColor = nextIdentityColor();
            _colorFavIndex = settings.colorFavoritesList.indexOf(_randomColor);
          });
        },
      ),

      // A simple body with the centered color display
      body: Center(
        child: RandomColorDisplay(
          randomColor: _randomColor,
          // Navigate to the Color Preview screen when the user double-taps the color code/name
          onDoubleTap: () => utils.navigateTo(
            context,
            ColorPreviewScreen(color: _randomColor.color),
          ),
          // Copy the color hex code/name to the clipboard when the user long-presses it
          onLongPress: copyColor,
        ),
      ),

      // The shuffle floating action button
      floatingActionButton: FloatingActionButton.large(
        onPressed: _shuffleColor,
        tooltip: strings.shuffleTooltip,
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  toggleFav,
  colorInfo,
  colorPreview,
  availableColors,
}

/// The app bar of the Random Color screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element
    required this.colorType,
    required this.isFavorite,
    required this.onAction,
  });

  final ColorType colorType;

  /// Whether the current color is added to the favorites list.
  final bool isFavorite;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(strings.colorType[colorType]!),

      // The common operations displayed in this app bar
      actions: <Widget>[
        // The Favorite toggle icon button
        IconButton(
          icon: isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          tooltip: isFavorite ? strings.removeFavTooltip : strings.addFavTooltip,
          onPressed: () => onAction(_AppBarActions.toggleFav),
        ),

        // The Color Information icon button
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: strings.colorInfoTooltip,
          onPressed: () => onAction(_AppBarActions.colorInfo),
        ),

        // Add the Popup Menu items
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // The Color Preview popup menu item
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.colorPreview,
              child: Text(strings.colorPreviewMenuItem),
            ),

            const PopupMenuDivider(),

            // The Available Colors popup menu item
            PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.availableColors,
              child: Text(strings.availableColors(colorType)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
