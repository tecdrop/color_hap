// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../services/color_lookup_service.dart' as color_lookup;
import '../utils/color_utils.dart' as color_utils;
import '../utils/utils.dart' as utils;
import '../widgets/color_info_display.dart';
import '../widgets/rgb_sliders.dart';
import 'edit_color_screen.dart';

/// A screen for tweaking colors with RGB sliders.
class ColorTweakScreen extends StatefulWidget {
  const ColorTweakScreen({
    super.key,
    required this.initialColor,
  });

  /// The initial color to display and edit.
  final Color initialColor;

  @override
  State<ColorTweakScreen> createState() => _ColorTweakScreenState();
}

class _ColorTweakScreenState extends State<ColorTweakScreen> with SingleTickerProviderStateMixin {
  /// The current color being edited.
  late Color _currentColor;

  /// The current color item corresponding to the current color.
  late ColorItem _currentColorItem;

  @override
  void initState() {
    super.initState();
    _updateColor(widget.initialColor, updateState: false);
  }

  /// Updates the current color and the corresponding color item and optionally updates the state.
  void _updateColor(Color color, {bool updateState = true}) {
    _currentColor = color;

    // Check if the color is a known color, otherwise create a true color item
    _currentColorItem =
        color_lookup.findKnownColor(color) ??
        ColorItem(
          type: .trueColor,
          color: color,
          listPosition: color_utils.toRGB24(color),
        );

    // Update the state if required
    if (updateState) setState(() {});
  }

  /// Navigates to the EditColorScreen to allow the user to edit the color code.
  Future<void> _editColorCode() async {
    final newColor = await utils.navigateTo<Color>(
      context,
      EditColorScreen(initialColor: _currentColor),
    );

    if (newColor != null) _updateColor(newColor);
  }

  /// Performs the specified action on the app bar.
  void _onAppBarAction(BuildContext context, _AppBarActions action) {
    switch (action) {
      // Applies the current color selection
      case .applyColor:
        Navigator.of(context).pop<ColorItem>(_currentColorItem);
        break;

      // Navigates to the EditColorScreen to edit the color code
      case .editColorCode:
        _editColorCode();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = color_utils.contrastColor(_currentColor);

    // Determine layout based on screen width
    final isWideLayout = MediaQuery.sizeOf(context).width >= 600;

    // Reusable color info widget
    final colorInfo = ColorInfoDisplay(
      colorItem: _currentColorItem,
      contrastColor: contrastColor,
      adaptiveHexSize: true,
      centered: true,
      showType: _currentColorItem.type != .trueColor,
      size: .medium,
    );

    final landscapeLayout = Row(
      children: [
        // Color information display in the center of the left half
        Expanded(
          child: Center(child: colorInfo),
        ),

        // RGB sliders in the center of the right half
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600.0),
              child: RgbSliders(
                initialColor: _currentColor,
                layout: .horizontal,
                onColorChanged: _updateColor,
              ),
            ),
          ),
        ),
      ],
    );

    final portraitLayout = Column(
      children: [
        // Color information display filling the available space at the top
        Expanded(
          child: Padding(
            padding: const .symmetric(vertical: 16.0),
            child: colorInfo,
          ),
        ),

        // RGB sliders at the bottom
        Padding(
          padding: const .only(bottom: 48.0),
          child: RgbSliders(
            initialColor: _currentColor,
            layout: .vertical,
            onColorChanged: _updateColor,
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: _currentColor,

      // The app bar with actions
      appBar: _AppBar(
        onAction: (action) => _onAppBarAction(context, action),
      ),

      // The body with color info and RGB sliders
      body: Padding(
        padding: const .all(16.0),
        child: isWideLayout ? landscapeLayout : portraitLayout,
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions { applyColor, editColorCode }

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.onAction,
  });

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(strings.colorTweakScreenTitle),

      /// The common operations displayed in this app bar
      actions: [
        /// The Apply Color action
        TextButton.icon(
          icon: const Icon(Icons.check),
          label: const Text(strings.applyColorAction),
          onPressed: () => onAction(.applyColor),
        ),

        // Add the overflow menu
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // Add the Edit Color Code action to the overflow menu
            const PopupMenuItem<_AppBarActions>(
              value: .editColorCode,
              child: Text(strings.editColorCodeAction),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
