// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_settings.dart' as settings;
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/utils.dart';
import '../widgets/color_info_list.dart';

/// The Color Details screen.
///
/// Displays the given [RandomColor] in different formats, and other color information, and allows
/// the user to toggle the visibility of the color information.
class ColorDetailsScreen extends StatefulWidget {
  const ColorDetailsScreen({
    super.key,
    required this.randomColor,
  });

  /// The random color to display in the Color Details screen.
  final RandomColor randomColor;

  @override
  State<ColorDetailsScreen> createState() => _ColorDetailsScreenState();
}

class _ColorDetailsScreenState extends State<ColorDetailsScreen> {
  /// Toggles the visibility of the color information.
  void toggleColorInformation() {
    setState(() {
      settings.showColorInformation = !settings.showColorInformation;
    });
  }

  /// When a color information item is tapped, copy the value to the Clipboard, and show a
  /// confirmation SnackBar.
  Future<void> onInfoItemTap(String key, String value) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    Utils.showSnackBarForAsync(messengerState, strings.copiedSnack(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.randomColor.color,
      appBar: _buildAppBar(),
      body: settings.showColorInformation
          // Show the color information list
          ? ColorInfoList(
              randomColor: widget.randomColor,
              onInfoItemTap: onInfoItemTap,
            )
          // Don't show anything, just the color as the background
          : const SizedBox.shrink(),
    );
  }

  /// Builds the app bar for the Color Details screen.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(strings.colorDetailsScreenTitle),
      actions: [
        // The toggle color information action button
        IconButton(
          icon: settings.showColorInformation
              ? const Icon(Icons.visibility_off_outlined)
              : const Icon(Icons.visibility_outlined),
          tooltip: strings.toggleColorInformation,
          onPressed: toggleColorInformation,
        ),
      ],
    );
  }
}
