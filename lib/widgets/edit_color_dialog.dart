// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_utils.dart' as color_utils;

/// Shows a dialog to edit a color by entering its hex code.
///
/// The dialog allows the user to type, edit, or paste a 6-digit hex color code.
/// The dialog background updates in real-time to preview the color as the user types.
///
/// Returns the new [Color] if the user confirms, or null if cancelled.
Future<Color?> showEditColorDialog({
  required BuildContext context,
  required Color initialColor,
}) {
  return showDialog<Color>(
    context: context,
    builder: (context) => _EditColorDialog(initialColor: initialColor),
  );
}

/// Private dialog widget for editing color hex codes.
class _EditColorDialog extends StatefulWidget {
  const _EditColorDialog({required this.initialColor});

  final Color initialColor;

  @override
  State<_EditColorDialog> createState() => _EditColorDialogState();
}

class _EditColorDialogState extends State<_EditColorDialog> {
  late TextEditingController _controller;
  late Color _previewColor;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _previewColor = widget.initialColor;

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

  void _onTextChanged() {
    final text = _controller.text;

    // Validate hex string (must be 6 characters, 0-9 A-F)
    if (text.length == 6) {
      final color = color_utils.rgbHexToColor(text);
      if (color != null) {
        setState(() {
          _previewColor = color;
          _isValid = true;
        });
        return;
      }
    }

    // Invalid input
    setState(() {
      _isValid = false;
    });
  }

  void _onConfirm() {
    if (_isValid && _controller.text.length == 6) {
      Navigator.of(context).pop<Color>(_previewColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = color_utils.contrastColor(_previewColor);

    return AlertDialog(
      backgroundColor: _previewColor,
      title: Text(
        'Enter Color Code',
        style: TextStyle(color: contrastColor),
      ),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Static "#" prefix
          Text(
            '#',
            style: TextStyle(
              color: contrastColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),

          // Hex input field
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 6,
              style: TextStyle(
                color: contrastColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                counterText: '', // Hide character counter
                border: InputBorder.none,
                hintText: 'RRGGBB',
                hintStyle: TextStyle(
                  color: contrastColor.withValues(alpha: 0.4),
                  letterSpacing: 1.2,
                ),
                errorText: _isValid ? null : 'Invalid hex',
                errorStyle: TextStyle(color: contrastColor),
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
              onSubmitted: (_) => _onConfirm(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<Color>(),
          child: Text('Cancel', style: TextStyle(color: contrastColor)),
        ),
        TextButton(
          onPressed: _isValid && _controller.text.length == 6 ? _onConfirm : null,
          child: Text('Apply', style: TextStyle(color: contrastColor)),
        ),
      ],
    );
  }
}
