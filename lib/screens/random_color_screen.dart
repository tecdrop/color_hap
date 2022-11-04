// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// cSpell:ignore fullscreen

import 'package:flutter/material.dart';

import '../common/app_const.dart';
import '../common/app_settings.dart' as app_settings;
import '../common/ui_strings.dart';
import '../models/nameable_color.dart';
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

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  // The current random nameable color.
  NameableColor _nameableColor = const NameableColor(
    color: AppConst.defaultColor,
    type: ColorType.trueColor,
  );

  // The random color generator.
  late RandomColor randomColor;

  /// Creates the appropriate random color generator and shuffles the color on init state.
  @override
  void initState() {
    super.initState();

    randomColor = RandomColor.fromType(widget.colorType);
    _shuffleColor();
  }

  /// Performs the actions of the app bar.
  Future<void> _onAction(_AppBarActions action) async {
    switch (action) {

      // Open the Color Information screen with the current color
      case _AppBarActions.colorInfo:
        await Navigator.pushNamed(context, AppConst.colorInfoRoute, arguments: _nameableColor);
        break;

      // Toggle the fullscreen mode, including the platform's fullscreen mode
      case _AppBarActions.fullScreenMode:
        setState(() {
          app_settings.fullScreenMode = !app_settings.fullScreenMode;
        });
        Utils.toggleSystemFullscreen(app_settings.fullScreenMode);
        break;
    }
  }

  /// Generates a new random nameable color.
  void _shuffleColor() {
    final NameableColor nameableColor = randomColor.next();
    setState(() {
      _nameableColor = nameableColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use an AnimatedSwitcher as a root widget to animate between the previous and current color
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: Scaffold(
        key: ValueKey(_nameableColor.color.value), // required for the AnimatedSwitcher to work
        backgroundColor: _nameableColor.color,

        // The app bar
        appBar: _AppBar(
          title: Text(UIStrings.colorType[widget.colorType]!),
          fullScreenMode: app_settings.fullScreenMode,
          color: _nameableColor.color,
          onAction: _onAction,
        ),

        // The app drawer
        drawer: AppDrawer(
          nameableColor: _nameableColor,
          colorType: widget.colorType,
        ),

        // A simple body with the centered color display
        body: Center(child: ColorDisplay(nameableColor: _nameableColor)),

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
  fullScreenMode,
}

/// The app bar of the Random Color screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    Key? key,
    required this.title,
    required this.fullScreenMode,
    required this.color,
    required this.onAction,
  }) : super(key: key);

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// The color of the app bar in fullscreen mode.
  final Color color;

  /// Whether the screen is currently in fullscreen mode.
  final bool fullScreenMode;

  /// The callback that is called when an app bar action is pressed.
  final Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: fullScreenMode ? null : title,

      // In fullscreen mode seamlessly fill the app bar with the current color
      backgroundColor: fullScreenMode ? color : null,
      foregroundColor: fullScreenMode ? ColorUtils.contrastOf(color) : null,
      elevation: fullScreenMode ? 0.0 : null,

      // The common operations displayed in this app bar
      actions: <Widget>[
        IconButton(
          icon: fullScreenMode ? const Icon(Icons.fullscreen_exit) : const Icon(Icons.fullscreen),
          tooltip: UIStrings.fullScreenTooltip,
          onPressed: () => onAction(_AppBarActions.fullScreenMode),
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
