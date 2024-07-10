// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/app_const.dart' as consts;
import '../common/app_routes.dart';
import '../common/app_settings.dart' as settings;
import '../common/ui_strings.dart' as strings;
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/utils.dart' as utils;
import '../widgets/internal/app_drawer.dart';
import '../widgets/random_color_display.dart';

/// The Random Color screen, that is the home screen of the app.
///
/// It displays the current random color, and lets the user to generate new random colors.
class RandomColorScreen extends StatefulWidget {
  const RandomColorScreen({
    super.key,
    required this.colorType,
  });

  /// The type of random colors that are currently generated in this screen.
  final ColorType colorType;

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  // The current random color.
  RandomColor _randomColor = const RandomColor(
    color: consts.defaultColor,
    type: ColorType.trueColor,
  );

  // The index of the current color in the favorites list.
  int _colorFavIndex = -1;

  /// Generates a new random color on state initialization.
  @override
  void initState() {
    super.initState();

    _shuffleColor();
  }

  /// Generates a new random color if the color type has changed.
  @override
  void didUpdateWidget(RandomColorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.colorType != widget.colorType) {
      _shuffleColor();
    }
  }

  /// Performs the actions of the app bar.
  void _onAction(_AppBarActions action) {
    switch (action) {
      case _AppBarActions.toggleFav:
        // Toggle the current color in the favorites list
        setState(() {
          _colorFavIndex = settings.colorFavoritesList.toggle(_randomColor, index: _colorFavIndex);
          settings.saveColorFavoritesList();
        });
        break;
      // Open the Color Information screen with the current color
      case _AppBarActions.colorInfo:
        gotoColorInfoRoute(context, _randomColor);
        break;
    }
  }

  /// Generates a new random color.
  void _shuffleColor() {
    final RandomColor randomColor = nextRandomColor(widget.colorType);
    _colorFavIndex = settings.colorFavoritesList.indexOf(randomColor);
    setState(() {
      _randomColor = randomColor;
    });
  }

  /// Copies the current color hex code and name (if available) to the clipboard.
  Future<void> copyColor() async {
    final String hexCode = color_utils.toHexString(_randomColor.color);
    final String value = _randomColor.name != null ? '$hexCode ${_randomColor.name}' : hexCode;
    await utils.copyToClipboard(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar
      appBar: _AppBar(
        title: Text(strings.colorType[widget.colorType]!),
        isFavorite: _colorFavIndex >= 0,
        onAction: _onAction,
      ),

      // The app drawer
      drawer: AppDrawer(
        randomColor: _randomColor,
        colorType: widget.colorType,
        onShouldUpdateState: () => setState(() {
          _colorFavIndex = settings.colorFavoritesList.indexOf(_randomColor);
        }),
      ),

      // A simple body with the centered color display
      body: Center(
        child: RandomColorDisplay(
          randomColor: _randomColor,
          // Navigate to the Color Preview screen when the user double-taps the color code/name
          onDoubleTap: () => gotoColorPreviewRoute(context, _randomColor.color),
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
}

/// The app bar of the Random Color screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    // ignore: unused_element
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onAction,
  });

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// Whether the current color is added to the favorites list.
  final bool isFavorite;

  /// The callback that is called when an app bar action is pressed.
  final Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,

      // The common operations displayed in this app bar
      actions: <Widget>[
        IconButton(
          icon: isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          tooltip: isFavorite ? strings.removeFavTooltip : strings.addFavTooltip,
          onPressed: () => onAction(_AppBarActions.toggleFav),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: strings.colorInfoTooltip,
          onPressed: () => onAction(_AppBarActions.colorInfo),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
