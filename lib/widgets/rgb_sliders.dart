// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that provides RGB color adjustment controls.
///
/// Displays three sliders with text input controls for adjusting the red, green, and blue
/// components of a color. Each slider has a colored track and is accompanied by +/- buttons
/// and a text field for precise value entry.
class RgbSliders extends StatefulWidget {
  const RgbSliders({
    super.key,
    required this.color,
    required this.onColorChanged,
    required this.contrastColor,
  });

  /// The current color being edited.
  final Color color;

  /// Callback invoked when the color changes.
  final ValueChanged<Color> onColorChanged;

  /// The contrast color for UI elements (black or white based on background).
  final Color contrastColor;

  @override
  State<RgbSliders> createState() => _RgbSlidersState();
}

class _RgbSlidersState extends State<RgbSliders> {
  late int _red;
  late int _green;
  late int _blue;

  @override
  void initState() {
    super.initState();
    _updateFromColor(widget.color);
  }

  @override
  void didUpdateWidget(RgbSliders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _updateFromColor(widget.color);
    }
  }

  void _updateFromColor(Color color) {
    _red = (color.r * 255).round();
    _green = (color.g * 255).round();
    _blue = (color.b * 255).round();
  }

  void _notifyColorChange() {
    widget.onColorChanged(Color.fromARGB(
      255,
      _red,
      _green,
      _blue,
    ));
  }

  void _updateRed(int value) {
    setState(() {
      _red = value.clamp(0, 255);
      _notifyColorChange();
    });
  }

  void _updateGreen(int value) {
    setState(() {
      _green = value.clamp(0, 255);
      _notifyColorChange();
    });
  }

  void _updateBlue(int value) {
    setState(() {
      _blue = value.clamp(0, 255);
      _notifyColorChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          _RgbSliderRow(
            value: _red,
            color: Colors.red,
            contrastColor: widget.contrastColor,
            onChanged: _updateRed,
          ),
          const SizedBox(height: 16.0),
          _RgbSliderRow(
            value: _green,
            color: Colors.green,
            contrastColor: widget.contrastColor,
            onChanged: _updateGreen,
          ),
          const SizedBox(height: 16.0),
          _RgbSliderRow(
            value: _blue,
            color: Colors.blue,
            contrastColor: widget.contrastColor,
            onChanged: _updateBlue,
          ),
        ],
      ),
    );
  }
}

/// A single RGB slider row with value control.
class _RgbSliderRow extends StatelessWidget {
  const _RgbSliderRow({
    required this.value,
    required this.color,
    required this.contrastColor,
    required this.onChanged,
  });

  final int value;
  final Color color;
  final Color contrastColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.3),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
              valueIndicatorColor: color,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12.0,
                elevation: 2.0,
                pressedElevation: 4.0,
              ),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 255,
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        _RgbValueControl(
          value: value,
          contrastColor: contrastColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Value control with +/- buttons and text field.
class _RgbValueControl extends StatefulWidget {
  const _RgbValueControl({
    required this.value,
    required this.contrastColor,
    required this.onChanged,
  });

  final int value;
  final Color contrastColor;
  final ValueChanged<int> onChanged;

  @override
  State<_RgbValueControl> createState() => _RgbValueControlState();
}

class _RgbValueControlState extends State<_RgbValueControl> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_RgbValueControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateAndUpdate();
    }
  }

  void _validateAndUpdate() {
    final parsed = int.tryParse(_controller.text);
    if (parsed != null) {
      final clamped = parsed.clamp(0, 255);
      _controller.text = clamped.toString();
      if (clamped != widget.value) {
        widget.onChanged(clamped);
      }
    } else {
      _controller.text = widget.value.toString();
    }
  }

  void _decrement() {
    if (widget.value > 0) {
      widget.onChanged(widget.value - 1);
    }
  }

  void _increment() {
    if (widget.value < 255) {
      widget.onChanged(widget.value + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: widget.value > 0 ? _decrement : null,
          color: widget.contrastColor,
          iconSize: 20.0,
        ),
        SizedBox(
          width: 56.0,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: .number,
            textAlign: .center,
            style: TextStyle(color: widget.contrastColor),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: widget.contrastColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.contrastColor.withValues(alpha: 0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.contrastColor),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            onSubmitted: (_) => _validateAndUpdate(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.value < 255 ? _increment : null,
          color: widget.contrastColor,
          iconSize: 20.0,
        ),
      ],
    );
  }
}
