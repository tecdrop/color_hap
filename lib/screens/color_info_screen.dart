// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:share_plus/share_plus.dart';

import '../common/consts.dart' as consts;
import '../common/strings.dart' as strings;
import '../common/urls.dart' as urls;
import '../models/color_item.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/utils.dart' as utils;
import '../widgets/color_info_list.dart';
import 'color_preview_screen.dart';

/// The Color Info screen.
///
/// Displays the given [RandomColor] in different formats, and other color information, and allows
/// the user to copy or share the information.
class ColorInfoScreen extends StatefulWidget {
  const ColorInfoScreen({super.key, required this.colorItem});

  /// The random color to display in the Color Info screen.
  final ColorItem colorItem;

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
    final Color color = widget.colorItem.color;
    _infos = [
      if (widget.colorItem.name != null) ...[
        (key: strings.colorTitleInfo, value: widget.colorItem.longTitle),
        (key: strings.colorNameInfo, value: widget.colorItem.name!),
      ],
      (key: strings.hexInfo, value: color_utils.toHexString(color)),
      (key: strings.colorTypeInfo, value: strings.randomColorType(widget.colorItem.type)),
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
        // gotoColorPreviewRoute(context, widget.randomColor.color);
        utils.navigateTo(context, ColorPreviewScreen(color: widget.colorItem.color));
        break;

      // Opens the web browser to search for the current color
      case _AppBarActions.colorWebSearch:
        final String url = urls.onlineSearch + Uri.encodeComponent(widget.colorItem.longTitle);
        utils.launchUrlExternal(context, url);
        break;

      // Copies all the color information to the clipboard
      case _AppBarActions.copyAll:
        _copyAll();
        break;

      // Shares all the color information
      case _AppBarActions.shareAll:
        _shareAll();
        break;
    }
  }

  /// Copies the value of the item in the list that the user wants to copy.
  Future<void> _copyItem(BuildContext context, String key, String value) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    utils.showSnackBarForAsync(messengerState, strings.copiedSnack(value));
  }

  /// Share the value of the item in the list that the user wants to share.
  void _shareItem(String key, String value) {
    SharePlus.instance.share(ShareParams(text: value));
  }

  /// Copies all the color information to the clipboard.
  Future<void> _copyAll() async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: _infosAsString));
    utils.showSnackBarForAsync(messengerState, strings.allInfoCopied);
  }

  /// Shares all the color information.
  void _shareAll() async {
    SharePlus.instance.share(ShareParams(text: _infosAsString));
  }

  /// Shares the color swatch image.
  Future<void> _shareColorSwatch() async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    try {
      // Generate the color swatch image file name
      final String hexCode = color_utils.toHexString(widget.colorItem.color, withHash: false);
      final String fileName = consts.colorSwatchFileName(hexCode);

      // Create the color swatch image file
      Uint8List pngBytes = await color_utils.buildColorSwatch(widget.colorItem.color, 512, 512);
      final XFile xFile = XFile.fromData(pngBytes, name: fileName, mimeType: 'image/png');

      // Summon the platform's share sheet to share the image file
      await SharePlus.instance.share(
        ShareParams(
          text: strings.shareSwatchMessage(widget.colorItem.longTitle),
          files: [xFile],
        ),
      );
    } catch (e) {
      utils.showSnackBarForAsync(messengerState, strings.shareSwatchError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colorItem.color,

      // The app bar with the title and Color Preview and Color Web Search actions
      appBar: _AppBar(
        title: const Text(strings.colorInfoScreenTitle),
        onAction: (action) => _onAppBarAction(context, action),
      ),

      // The body of the screen with the color information list
      body: ColorInfoList(
        color: widget.colorItem.color,
        infos: _infos,
        onCopyPressed: (key, value) => _copyItem(context, key, value),
        onSharePressed: (key, value) => _shareItem(key, value),
      ),

      // The Share Swatch floating action button
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.share_outlined),
        label: const Text(strings.shareSwatchFAB),
        onPressed: _shareColorSwatch,
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions { colorPreview, colorWebSearch, copyAll, shareAll }

/// The app bar of the Color Info screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element_parameter
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

        // Add the overflow menu
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // Add the Copy All action to the overflow menu
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.copyAll,
              child: Text(strings.copyAllAction),
            ),

            // Add the Share All action to the overflow menu
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.shareAll,
              child: Text(strings.shareAllAction),
            ),

            // Add the Color Web Search action to the overflow menu
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.colorWebSearch,
              child: Text(strings.colorWebSearchAction),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
