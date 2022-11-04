// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:share_plus/share_plus.dart';

import '../common/app_urls.dart';
import '../common/ui_strings.dart';
import '../models/nameable_color.dart';
import '../utils/color_utils.dart';
import '../utils/utils.dart';

/// The Color Information screen.
///
/// Displays the given [NameableColor] in different formats, and allows the user to copy, share, or
/// search the Internet for any of the color information.
class ColorInfoScreen extends StatefulWidget {
  const ColorInfoScreen({
    super.key,
    required this.nameableColor,
    this.fullScreenMode = false,
  });

  /// The nameable color to display in the information screen.
  final NameableColor nameableColor;

  /// Whether the screen is currently in fullscreen mode.
  final bool fullScreenMode;

  @override
  State<ColorInfoScreen> createState() => _ColorInfoScreenState();
}

/// A key/value pair representing a piece of color information.
class _InfoItem {
  final String key;
  final String value;

  _InfoItem(this.key, this.value);
}

class _ColorInfoScreenState extends State<ColorInfoScreen> {
  /// The index of the currently selected information item in the list view.
  int _selectedIndex = 0;

  /// The color information list.
  final List<_InfoItem> _infoList = [];

  /// Build the color information list on init state.
  @override
  void initState() {
    super.initState();
    _buildInfoList(widget.nameableColor);
  }

  /// When the copy FAB is pressed, copy the currently selected color information item to the
  ///  Clipboard, and show a confirmation SnackBar.
  Future<void> _onCopyPressed() async {
    final String value = _infoList[_selectedIndex].value;
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    Utils.showSnackBarForAsync(messengerState, UIStrings.copiedSnack(value));
  }

  /// When the share FAB is pressed, share the currently selected color information item via the
  ///  platform's share dialog.
  void _onSharePressed() {
    final String value = _infoList[_selectedIndex].value;
    Share.share(value, subject: UIStrings.appName);
  }

  /// When the search FAB is pressed, perform a web search for the currently selected color
  ///  information item.
  void _onSearchPressed() {
    final String value = _infoList[_selectedIndex].value;
    final String url = AppUrls.onlineSearch + Uri.encodeComponent(value);
    Utils.launchUrlExternal(context, url);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).size.height >= 500;
    final Color color = widget.nameableColor.color;
    final Color contrastColor = ColorUtils.contrastOf(color);
    final Color selectedTileColor = Color.alphaBlend(contrastColor.withOpacity(0.25), color);
    final Color selectedColor = ColorUtils.contrastOf(selectedTileColor);

    return Scaffold(
      // Fill the color information screen with the current color
      backgroundColor: color,

      // A simple app bar with just the screen title. In fullscreen mode it is also seamless filled
      // with the current color.
      appBar: AppBar(
        title: widget.fullScreenMode ? null : const Text(UIStrings.colorInfoScreenTitle),
        backgroundColor: widget.fullScreenMode ? color : null,
        foregroundColor: widget.fullScreenMode ? ColorUtils.contrastOf(color) : null,
        elevation: widget.fullScreenMode ? 0.0 : null,
      ),

      // The body contains a list view with all the color information items
      body: ListTileTheme(
        textColor: contrastColor,
        selectedColor: selectedColor,
        selectedTileColor: selectedTileColor,
        child: ListView.builder(
          itemCount: _infoList.length,
          itemBuilder: (BuildContext context, int index) => _buildInfoListTile(index),
        ),
      ),
      floatingActionButton: _buildFABs(isPortrait),
    );
  }

  /// Builds the color information list.
  void _buildInfoList(NameableColor nameableColor) {
    // Simply a convenience function that adds the given key/value info to the list.
    void addInfoItem(String key, String value) => _infoList.add(_InfoItem(key, value));

    final Color color = nameableColor.color;

    if (nameableColor.name != null) {
      addInfoItem(UIStrings.colorTitleInfo, nameableColor.title);
      addInfoItem(UIStrings.colorNameInfo, nameableColor.name!);
    }
    addInfoItem(UIStrings.hexInfo, ColorUtils.toHexString(color));
    addInfoItem(UIStrings.colorTypeInfo, UIStrings.colorType[nameableColor.type]!);
    addInfoItem(UIStrings.rgbInfo, ColorUtils.toRGBString(color));
    addInfoItem(UIStrings.hsvInfo, ColorUtils.toHSVString(color));
    addInfoItem(UIStrings.hslInfo, ColorUtils.toHSLString(color));
    addInfoItem(UIStrings.decimalInfo, ColorUtils.toDecimalString(color));
    addInfoItem(UIStrings.luminanceInfo, ColorUtils.luminanceString(color));
    addInfoItem(UIStrings.brightnessInfo, ColorUtils.brightnessString(color));
  }

  /// Returns a list tile with the name and value of the color information at the given [index].
  Widget _buildInfoListTile(int index) {
    final _InfoItem infoEntry = _infoList[index];

    return ListTile(
      subtitle: Text(infoEntry.key),
      title: Text(infoEntry.value),
      selected: index == _selectedIndex,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  /// Builds the three main floating action buttons for copying, sharing and searching for the
  /// currently selected color info.
  Widget _buildFABs(bool isPortrait) {
    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          heroTag: 'copyFAB',
          onPressed: _onCopyPressed,
          tooltip: UIStrings.copyTooltip,
          child: const Icon(Icons.copy),
        ),
        isPortrait ? const SizedBox(height: 16.0) : const SizedBox(width: 16.0),
        FloatingActionButton(
          heroTag: 'shareFAB',
          onPressed: _onSharePressed,
          tooltip: UIStrings.shareTooltip,
          child: const Icon(Icons.share),
        ),
        isPortrait ? const SizedBox(height: 16.0) : const SizedBox(width: 16.0),
        FloatingActionButton(
          heroTag: 'searchFAB',
          onPressed: _onSearchPressed,
          tooltip: UIStrings.searchTooltip,
          child: const Icon(Icons.search),
        ),
      ],
    );
  }
}
