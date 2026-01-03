// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../services/color_lookup_service.dart' as color_lookup;
import '../utils/color_utils.dart' as color_utils;
import '../widgets/color_info_display.dart';
import '../widgets/edit_color_dialog.dart';
import '../widgets/rgb_sliders.dart';

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
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  void _onColorChanged(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  Future<void> _editColorCode() async {
    final newColor = await showEditColorDialog(
      context: context,
      initialColor: _currentColor,
    );

    if (newColor != null) {
      setState(() {
        _currentColor = newColor;
      });
    }
  }

  void _applyColor() {
    // Create ColorItem from current color using lookup service
    final knownColor = color_lookup.findKnownColor(_currentColor);
    final colorItem =
        knownColor ??
        ColorItem(
          type: .trueColor,
          color: _currentColor,
          listPosition: color_utils.toRGB24(_currentColor),
        );

    Navigator.of(context).pop<ColorItem>(colorItem);
  }

  /// Performs the specified action on the app bar.
  void _onAppBarAction(BuildContext context, _AppBarActions action) {
    switch (action) {
      // Applies the current color selection
      case .applyColor:
        _applyColor();
        break;

      // Shows dialog to edit color code
      case .editColorCode:
        _editColorCode();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = color_utils.contrastColor(_currentColor);
    final knownColor = color_lookup.findKnownColor(_currentColor);
    final colorItem =
        knownColor ??
        ColorItem(
          type: .trueColor,
          color: _currentColor,
          listPosition: color_utils.toRGB24(_currentColor),
        );

    return Scaffold(
      backgroundColor: _currentColor,
      resizeToAvoidBottomInset: false,
      appBar: _AppBar(
        onAction: (action) => _onAppBarAction(context, action),
      ),
      body: Column(
        children: [
          // Color information display
          Expanded(
            child: Padding(
              padding: const .all(16.0),
              child: ColorInfoDisplay(
                colorItem: colorItem,
                contrastColor: contrastColor,
                adaptiveHexSize: true,
                centered: true,
                showType: knownColor != null,
                size: .medium,
              ),
            ),
          ),

          // RGB sliders
          Padding(
            padding: const .only(bottom: 48.0),
            child: RgbSliders(
              initialColor: _currentColor,
              onColorChanged: _onColorChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions { applyColor, editColorCode }

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element_parameter
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
