// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_settings.dart' as settings;
import '../common/app_urls.dart';
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/utils.dart' as utils;
import '../widgets/color_info_list.dart';

/// The Color Info screen.
///
/// Displays the given [RandomColor] in different formats, and other color information, and allows
/// the user to toggle the visibility of the color information.
class ColorInfoScreen extends StatefulWidget {
  const ColorInfoScreen({
    super.key,
    required this.randomColor,
  });

  /// The random color to display in the Color Info screen.
  final RandomColor randomColor;

  @override
  State<ColorInfoScreen> createState() => _ColorInfoScreenState();
}

class _ColorInfoScreenState extends State<ColorInfoScreen> {
  /// Performs the specified action on the app bar.
  void _onAppBarAction(_AppBarActions action) {
    switch (action) {
      // Toggles the visibility of the color information list
      case _AppBarActions.toggleInfo:
        setState(() {
          settings.showColorInformation = !settings.showColorInformation;
        });
        break;
      // Opens the web browser to search for the current color
      case _AppBarActions.webSearch:
        final String url = AppUrls.onlineSearch + Uri.encodeComponent(widget.randomColor.title);
        utils.launchUrlExternal(context, url);
        break;
    }
  }

  /// When the user presses the copy button on an item in the list, copy the value to the Clipboard,
  /// and show a confirmation SnackBar.
  Future<void> onItemCopyPressed(String key, String value) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    utils.showSnackBarForAsync(messengerState, strings.copiedSnack(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.randomColor.color,
      appBar: _AppBar(
        title: const Text(strings.colorInfoScreenTitle),
        showColorInformation: settings.showColorInformation,
        onAction: _onAppBarAction,
      ),
      body: settings.showColorInformation
          // Show the color information list
          ? ColorInfoList(
              randomColor: widget.randomColor,
              onCopyPressed: onItemCopyPressed,
            )
          // Don't show anything, just the color as the background
          : const SizedBox.shrink(),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  toggleInfo,
  webSearch,
}

/// The app bar of the Color Info screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    Key? key,
    required this.title,
    required this.showColorInformation,
    required this.onAction,
  }) : super(key: key);

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// Whether the current color is added to the favorites list.
  final bool showColorInformation;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,

      // The common operations displayed in this app bar
      actions: <Widget>[
        // The toggle color information action button
        IconButton(
          icon: settings.showColorInformation
              ? const Icon(Icons.visibility_off_outlined)
              : const Icon(Icons.visibility_outlined),
          tooltip: strings.toggleColorInformation,
          onPressed: () => onAction(_AppBarActions.toggleInfo),
        ),
        // Add the Popup Menu items
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // The web search action
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.webSearch,
              child: Text(strings.webSearchColor),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
