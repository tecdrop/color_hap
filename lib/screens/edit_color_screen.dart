// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../services/color_lookup_service.dart' as color_lookup;
import '../utils/color_utils.dart' as color_utils;
import '../widgets/color_info_display.dart';
import '../widgets/transparency_grid.dart';

/// A screen that allows the user to edit a color by entering its hex code.
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

  /// The current color item if the color is a known color.
  ColorItem? _currentColorItem;

  /// Placeholder color item used to reserve space when no known color is found.
  static const _placeholderColorItem = ColorItem(
    type: .basicColor,
    color: Colors.black,
    name: '',
    listPosition: 0,
  );

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;

    // Initialize with hex code (with #)
    final hexString = color_utils.toHexString(widget.initialColor);
    _controller = TextEditingController(text: hexString);

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

    // Validate hex string (must be 7 characters, # and 0-9 A-F)
    if (text.length == 7) {
      final color = color_utils.rgbHexToColor(text);
      if (color != null) {
        setState(() {
          _currentColor = color;
          _currentColorItem = color_lookup.findKnownColor(color);
        });
        return;
      }
    }

    // Invalid input
    setState(() {
      _currentColor = null;
      _currentColorItem = null;
    });
  }

  /// Navigates back with the selected color when Apply is pressed.
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

    return TransparencyGrid(
      child: Scaffold(
        // Set the screen background to the current color inputed by the user
        // If no valid color, use transparent so the transparency grid shows through
        backgroundColor: _currentColor ?? Colors.transparent,

        // The app bar with the Apply action
        appBar: _AppBar(
          // Only enable the Apply action if there is a valid current color
          onApply: _currentColor != null ? _onApply : null,
        ),

        // The body with the hex input field and color info in the center
        body: Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              SizedBox(
                // An opinionated fixed width that fits "#RRGGBB" comfortably on all tested font sizes,
                // including the largest system accessibility font settings (tested on Android)
                width: 164.0,

                // The hex input field
                child: _HexInput(
                  foregroundColor: contrastColor,
                  controller: _controller,

                  // When the user presses Enter, navigate back with the color if valid
                  onSubmitted: (_) => _onApply(),
                ),
              ),

              /// The color info display for known colors below the input field; if no known color
              /// is found, we still reserve the space using a placeholder to prevent layout shifts
              const SizedBox(height: 16.0),
              Opacity(
                opacity: _currentColorItem != null ? 1.0 : 0.0,
                child: ColorInfoDisplay(
                  colorItem: _currentColorItem ?? _placeholderColorItem,
                  contrastColor: contrastColor,
                  showType: true,
                  showCode: false,
                  size: .small,
                  centered: true,
                  alwaysShowNameLine: true,
                ),
              ),
            ],
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
        /// The Apply action - only shown if [onApply] is not null
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

/// A text input field for entering a hex color code.
class _HexInput extends StatelessWidget {
  const _HexInput({
    super.key, // ignore: unused_element_parameter
    required this.foregroundColor,
    this.controller,
    this.onSubmitted,
  });

  /// The foreground color to use for text and borders.
  final Color foregroundColor;

  /// The text editing controller for the hex input field.
  final TextEditingController? controller;

  /// Callback for when the user submits the input (presses Enter).
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: foregroundColor, width: 2.0),
    );

    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,

      // Input field configuration
      autofocus: true,
      cursorColor: foregroundColor,
      keyboardType: .text,
      maxLength: 7,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: foregroundColor),
      textAlign: .center,
      textCapitalization: .characters,

      // Decoration for the input field
      decoration: InputDecoration(
        // Hide character counter
        counterText: '',

        // The underline border
        enabledBorder: border,
        focusedBorder: border,

        // The RRGGBB hint text
        hintText: strings.inputHexHint,
        hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: foregroundColor.withValues(alpha: 0.4),
        ),
      ),

      // Input formatters to restrict input to valid hex characters
      inputFormatters: [
        // 1. First, strict allow-list (this strips non-hex chars)
        FilteringTextInputFormatter.allow(RegExp('[0-9A-Fa-f]')),

        // 2. Then, enforce length (6 digits + 1 hash = 7 chars total)
        LengthLimitingTextInputFormatter(7),

        // 3. Finally, ensure '#' is present and uppercase
        _HexInputFormatter(),
      ],
    );
  }
}

/// A text input formatter that ensures the hex input is uppercase and prefixed with '#'.
class _HexInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 1. Always uppercase the input
    final upperText = newValue.text.toUpperCase();

    // 2. If the # is already there, we only needed to uppercase. Return as is.
    if (upperText.startsWith('#')) {
      return newValue.copyWith(text: upperText);
    }

    // 3. If missing, prepend '#' and shift the selection (cursor) +1
    return TextEditingValue(
      text: '#$upperText',
      selection: newValue.selection.copyWith(
        baseOffset: newValue.selection.baseOffset + 1,
        extentOffset: newValue.selection.extentOffset + 1,
      ),
    );
  }
}
