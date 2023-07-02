// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_const.dart';
import '../common/app_settings.dart' as app_settings;
import '../common/ui_strings.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../models/random_color.dart';
import '../utils/color_utils.dart';
import '../utils/utils.dart';
import '../widgets/color_display.dart';
import '../widgets/internal/app_drawer.dart';

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

  /// The route builder for the Random Color screen.
  static Widget routeBuilder(BuildContext context, GoRouterState state) {
    // Get the color type from the route parameters
    ColorType colorType = parseColorType(state.pathParameters['type']);

    // Return the Random Color screen with the provided color type
    return RandomColorScreen(
      colorType: colorType,
    );
  }

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  // The current random color.
  RandomColor _randomColor = const RandomColor(
    color: AppConst.defaultColor,
    type: ColorType.trueColor,
  );

  /// Creates the appropriate random color generator and shuffles the color on init state.
  @override
  void initState() {
    super.initState();

    _shuffleColor();
  }

  /// Performs the actions of the app bar.
  Future<void> _onAction(_AppBarActions action) async {
    switch (action) {
      // Open the Color Information screen with the current color
      case _AppBarActions.colorInfo:
        await Navigator.pushNamed(context, AppConst.colorInfoRoute, arguments: _randomColor);
        break;

      // Toggle the immersive mode, including the platform's fullscreen mode
      case _AppBarActions.toggleImmersive:
        setState(() {
          app_settings.immersiveMode = !app_settings.immersiveMode;
        });
        Utils.toggleSystemFullscreen(app_settings.immersiveMode);
        break;
    }
  }

  /// Generates a new random color.
  void _shuffleColor() {
    final RandomColor randomColor = nextRandomColor(widget.colorType);
    setState(() {
      _randomColor = randomColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use an AnimatedSwitcher as a root widget to animate between the previous and current color
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: Scaffold(
        key: ValueKey(_randomColor.color.value), // required for the AnimatedSwitcher to work
        backgroundColor: _randomColor.color,

        // The app bar
        appBar: _AppBar(
          title: Text(UIStrings.colorType[widget.colorType]!),
          immersiveMode: app_settings.immersiveMode,
          color: _randomColor.color,
          onAction: _onAction,
        ),

        // The app drawer
        drawer: AppDrawer(
          randomColor: _randomColor,
          colorType: widget.colorType,
        ),

        // A simple body with the centered color display
        body: Center(child: ColorDisplay(randomColor: _randomColor)),

        // The shuffle floating action button
        floatingActionButton: FloatingActionButton(
          onPressed: _shuffleColor,
          tooltip: UIStrings.shuffleTooltip,
          child: const Icon(Icons.shuffle),
        ),
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  colorInfo,
  toggleImmersive,
}

/// The app bar of the Random Color screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    Key? key,
    required this.title,
    required this.immersiveMode,
    required this.color,
    required this.onAction,
  }) : super(key: key);

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// The color of the app bar in immersive mode.
  final Color color;

  /// Whether the screen is currently in immersive mode.
  final bool immersiveMode;

  /// The callback that is called when an app bar action is pressed.
  final Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: immersiveMode ? null : title,

      // In immersive mode seamlessly fill the app bar with the current color
      backgroundColor: immersiveMode ? color : null,
      foregroundColor: immersiveMode ? ColorUtils.contrastOf(color) : null,
      elevation: immersiveMode ? 0.0 : null,

      // The common operations displayed in this app bar
      actions: <Widget>[
        IconButton(
          icon: immersiveMode ? const Icon(Icons.fullscreen_exit) : const Icon(Icons.fullscreen),
          tooltip: UIStrings.toggleImmersiveTooltip,
          onPressed: () => onAction(_AppBarActions.toggleImmersive),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: UIStrings.colorInfoTooltip,
          onPressed: () => onAction(_AppBarActions.colorInfo),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
