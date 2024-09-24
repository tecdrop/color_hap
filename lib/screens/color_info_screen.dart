// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_routes.dart';
import '../common/app_urls.dart' as urls;
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/utils.dart' as utils;
import '../widgets/color_info_list.dart';
import '../utils/color_utils.dart' as color_utils;

/// The Color Info screen.
///
/// Displays the given [RandomColor] in different formats, and other color information, and allows
/// the user to toggle the visibility of the color information.
class ColorInfoScreen extends StatelessWidget {
  const ColorInfoScreen({
    super.key,
    required this.randomColor,
  });

  /// The random color to display in the Color Info screen.
  final RandomColor randomColor;

  /// Performs the specified action on the app bar.
  void _onAppBarAction(BuildContext context, _AppBarActions action) {
    switch (action) {
      // Navigates to the Color Preview screen
      case _AppBarActions.colorPreview:
        gotoColorPreviewRoute(context, randomColor.color);
        break;

      // Opens the web browser to search for the current color
      case _AppBarActions.colorWebSearch:
        final String url = urls.onlineSearch + Uri.encodeComponent(randomColor.title);
        utils.launchUrlExternal(context, url);
        break;
    }
  }

  /// When the user presses the copy button on an item in the list, copy the value to the Clipboard,
  /// and show a confirmation SnackBar.
  Future<void> onItemCopyPressed(BuildContext context, String key, String value) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    utils.showSnackBarForAsync(messengerState, strings.copiedSnack(value));
  }

  @override
  Widget build(BuildContext context) {
    final Color color = randomColor.color;
    final List<({String key, String value})> infos = [
      if (randomColor.name != null) ...[
        (key: strings.colorTitleInfo, value: randomColor.title),
        (key: strings.colorNameInfo, value: randomColor.name!)
      ],
      (key: strings.hexInfo, value: color_utils.toHexString(color)),
      (key: strings.colorTypeInfo, value: strings.colorType[randomColor.type]!),
      (key: strings.rgbInfo, value: color_utils.toRGBString(color)),
      (key: strings.hsvInfo, value: color_utils.toHSVString(color)),
      (key: strings.hslInfo, value: color_utils.toHSLString(color)),
      (key: strings.decimalInfo, value: color_utils.toDecimalString(color)),
      (key: strings.luminanceInfo, value: color_utils.luminanceString(color)),
      (key: strings.brightnessInfo, value: color_utils.brightnessString(color)),
    ];

    return Scaffold(
      backgroundColor: color,
      appBar: _AppBar(
        title: const Text(strings.colorInfoScreenTitle),
        onAction: (action) => _onAppBarAction(context, action),
      ),
      body: ColorInfoList(
        randomColor: randomColor,
        infos: infos,
        onCopyPressed: (key, value) => onItemCopyPressed(context, key, value),
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  colorPreview,
  colorWebSearch,
}

/// The app bar of the Color Info screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    // ignore: unused_element
    super.key,
    required this.title,
    required this.onAction,
  });

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,

      // The common operations displayed in this app bar
      actions: <Widget>[
        // The Color Preview action
        IconButton(
          icon: const Icon(Icons.remove_red_eye_outlined),
          tooltip: strings.colorPreviewAction,
          onPressed: () => onAction(_AppBarActions.colorPreview),
        ),

        // The Color Web Search action
        IconButton(
          // icon: const Icon(custom_icons.search_web),
          icon: const Icon(Icons.language_outlined),
          tooltip: strings.colorWebSearchAction,
          onPressed: () => onAction(_AppBarActions.colorWebSearch),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
