// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/strings.dart' as strings;
import '../utils/color_utils.dart' as color_utils;
import '../widgets/transparency_grid.dart';

class EditColorScreen extends StatefulWidget {
  const EditColorScreen({
    super.key,
    required this.initialColor,
  });

  /// The initial color to display in the dialog.
  final Color initialColor;

  @override
  State<EditColorScreen> createState() => _EditColorScreenState();
}

class _EditColorScreenState extends State<EditColorScreen> {
  /// The text editing controller for the hex input field.
  late TextEditingController _controller;

  /// The current color based on user input.
  Color? _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;

    // Initialize with hex code (without #)
    final hexString = color_utils.toHexString(widget.initialColor, withHash: false);
    _controller = TextEditingController(text: hexString);

    // Select all text for easy replacement
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );

    // Listen to text changes and validate
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Callback for when the text in the input field changes.
  void _onTextChanged() {
    final text = _controller.text;

    // Validate hex string (must be 6 characters, 0-9 A-F)
    if (text.length == 6) {
      final color = color_utils.rgbHexToColor(text);
      if (color != null) {
        setState(() => _currentColor = color);
        return;
      }
    }

    // Invalid input
    setState(() => _currentColor = null);
  }

  void _onApply() {
    if (_currentColor != null) {
      Navigator.of(context).pop<Color>(_currentColor!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = _currentColor != null
        ? color_utils.contrastColor(_currentColor!)
        : Colors.black;

    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: contrastColor, width: 2.0),
    );

    return TransparencyGrid(
      child: Scaffold(
        backgroundColor: _currentColor ?? Colors.transparent,
        appBar: _AppBar(
          onApply: _currentColor != null ? _onApply : null,
        ),
        body: Center(
          child: SizedBox(
            width: 175,
            child: TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 6,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: contrastColor,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.tag),
                prefixIconColor: contrastColor,

                counterText: '', // Hide character counter
                enabledBorder: border,
                focusedBorder: border,

                hintText: 'RRGGBB',
                hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: contrastColor.withValues(alpha: 0.4),
                  letterSpacing: 1.2,
                ),
              ),
              inputFormatters: [
                // Only allow hex characters (0-9, A-F, case insensitive)
                FilteringTextInputFormatter.allow(RegExp('[0-9A-Fa-f]')),
                // Auto-uppercase
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              // onSubmitted: onSubmitted,
            ),
          ),
        ),
      ),
    );
  }
}

/// The app bar for the Edit Color screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element_parameter
    this.onApply,
  });

  /// Callback for when the Apply action is triggered.
  final void Function()? onApply;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(strings.editColorScreenTitle),

      /// The common operations displayed in this app bar
      actions: [
        /// The Apply Color action
        if (onApply != null)
          TextButton.icon(
            icon: const Icon(Icons.check),
            label: const Text(strings.applyColorAction),
            onPressed: onApply,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
