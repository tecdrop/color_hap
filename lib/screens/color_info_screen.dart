// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:share_plus/share_plus.dart';

import '../common/app_routes.dart';
import '../common/app_urls.dart' as urls;
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/utils.dart' as utils;
import '../widgets/color_info_list.dart';

/// The Color Info screen.
///
/// Displays the given [RandomColor] in different formats, and other color information, and allows
/// the user to copy or share the information.
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
  /// The list of color information to display.
  late final List<({String key, String value})> _infos;

  /// The string representation of the color information for copying or sharing.
  late final String _infosAsString;

  @override
  void initState() {
    super.initState();

    // Prepare the list of color information to display
    final Color color = widget.randomColor.color;
    _infos = [
      if (widget.randomColor.name != null) ...[
        (key: strings.colorTitleInfo, value: widget.randomColor.title),
        (key: strings.colorNameInfo, value: widget.randomColor.name!)
      ],
      (key: strings.hexInfo, value: color_utils.toHexString(color)),
      (key: strings.colorTypeInfo, value: strings.colorType[widget.randomColor.type]!),
      (key: strings.rgbInfo, value: color_utils.toRGBString(color)),
      (key: strings.hsvInfo, value: color_utils.toHSVString(color)),
      (key: strings.hslInfo, value: color_utils.toHSLString(color)),
      (key: strings.decimalInfo, value: color_utils.toDecimalString(color)),
      (key: strings.luminanceInfo, value: color_utils.luminanceString(color)),
      (key: strings.brightnessInfo, value: color_utils.brightnessString(color)),
    ];

    // Prepare the string representation of the color information for copying or sharing
    _infosAsString = _infos.map((info) => '${info.key}: ${info.value}').join('\n');
  }

  /// Performs the specified action on the app bar.
  void _onAppBarAction(BuildContext context, _AppBarActions action) {
    switch (action) {
      // Navigates to the Color Preview screen
      case _AppBarActions.colorPreview:
        gotoColorPreviewRoute(context, widget.randomColor.color);
        break;

      // Opens the web browser to search for the current color
      case _AppBarActions.colorWebSearch:
        final String url = urls.onlineSearch + Uri.encodeComponent(widget.randomColor.title);
        utils.launchUrlExternal(context, url);
        break;
    }
  }

  /// Copies the value of the item in the list that the user wants to copy.
  Future<void> _onItemCopyPressed(BuildContext context, String key, String value) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    utils.showSnackBarForAsync(messengerState, strings.copiedSnack(value));
  }

  /// Share the value of the item in the list that the user wants to share.
  void _onItemSharePressed(String key, String value) {
    Share.share(value);
  }

  /// Copies all the color information to the clipboard.
  Future<void> _onCopyAllPressed() async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: _infosAsString));
    utils.showSnackBarForAsync(messengerState, strings.allInfoCopied);
  }

  /// Shares all the color information.
  void _onShareAllPressed() {
    Share.share(_infosAsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.randomColor.color,

      // The app bar with the title and Color Preview and Color Web Search actions
      appBar: _AppBar(
        title: const Text(strings.colorInfoScreenTitle),
        onAction: (action) => _onAppBarAction(context, action),
      ),

      // The body of the screen with the color information list
      body: ColorInfoList(
        randomColor: widget.randomColor,
        infos: _infos,
        onCopyPressed: (key, value) => _onItemCopyPressed(context, key, value),
        onSharePressed: (key, value) => _onItemSharePressed(key, value),
      ),

      // The bottom app bar with the Copy All and Share All buttons
      bottomNavigationBar: _BottomAppBar(
        onCopyAllPressed: _onCopyAllPressed,
        onShareAllPressed: _onShareAllPressed,
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
          // icon: const Icon(Icons.language_outlined),
          icon: const Icon(Icons.open_in_browser_outlined),
          // icon: const Icon(Icons.web_outlined),
          // icon: const Icon(Icons.tab_outlined),
          tooltip: strings.colorWebSearchAction,
          onPressed: () => onAction(_AppBarActions.colorWebSearch),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// The bottom app bar of the Color Info screen.
class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
    super.key, // ignore: unused_element
    this.onCopyAllPressed,
    this.onShareAllPressed,
  });

  /// The callback that is called when the Copy All button is pressed.
  final void Function()? onCopyAllPressed;

  /// The callback that is called when the Share All button is pressed.
  final void Function()? onShareAllPressed;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Add the Copy All button to the bottom app bar
          TextButton.icon(
            icon: const Icon(Icons.copy_outlined),
            label: const Text(strings.copyAllButton),
            onPressed: onCopyAllPressed,
          ),

          const SizedBox(width: 16.0),

          // Add the Share All button to the bottom app bar
          FilledButton.icon(
            icon: const Icon(Icons.share_outlined),
            label: const Text(strings.shareAllButton),
            onPressed: onShareAllPressed,
          ),
        ],
      ),
    );
  }
}
