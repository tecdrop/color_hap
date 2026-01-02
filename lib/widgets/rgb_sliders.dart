// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// RGB color component (red, green, or blue).
enum RgbComponent { red, green, blue }

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

  late final Map<RgbComponent, TextEditingController> _controllers;

  static const _componentColors = {
    RgbComponent.red: Color(0xFFFF0000),
    RgbComponent.green: Color(0xFF00FF00),
    RgbComponent.blue: Color(0xFF0000FF),
  };

  @override
  void initState() {
    super.initState();
    _updateFromColor(widget.color);

    // Create controllers in a map
    _controllers = {
      RgbComponent.red: TextEditingController(text: _red.toString()),
      RgbComponent.green: TextEditingController(text: _green.toString()),
      RgbComponent.blue: TextEditingController(text: _blue.toString()),
    };
  }

  @override
  void didUpdateWidget(RgbSliders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _updateFromColor(widget.color);
      // Update all controller texts
      _controllers[RgbComponent.red]!.text = _red.toString();
      _controllers[RgbComponent.green]!.text = _green.toString();
      _controllers[RgbComponent.blue]!.text = _blue.toString();
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateFromColor(Color color) {
    _red = (color.r * 255).round();
    _green = (color.g * 255).round();
    _blue = (color.b * 255).round();
  }

  void _notifyColorChange() {
    widget.onColorChanged(Color.fromARGB(255, _red, _green, _blue));
  }

  int _getValue(RgbComponent component) => switch (component) {
        .red => _red,
        .green => _green,
        .blue => _blue,
      };

  void _updateComponent(RgbComponent component, int value) {
    setState(() {
      final clamped = value.clamp(0, 255);
      switch (component) {
        case .red:
          _red = clamped;
        case .green:
          _green = clamped;
        case .blue:
          _blue = clamped;
      }
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
          for (final component in RgbComponent.values) ...[
            _RgbSliderRow(
              component: component,
              value: _getValue(component),
              controller: _controllers[component]!,
              color: _componentColors[component]!,
              contrastColor: widget.contrastColor,
              onChanged: (value) => _updateComponent(component, value),
            ),
            if (component != .blue) const SizedBox(height: 16.0),
          ],
        ],
      ),
    );
  }
}

/// A single RGB slider row with value control.
class _RgbSliderRow extends StatelessWidget {
  const _RgbSliderRow({
    required this.component,
    required this.value,
    required this.controller,
    required this.color,
    required this.contrastColor,
    required this.onChanged,
  });

  final RgbComponent component;
  final int value;
  final TextEditingController controller;
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
              activeTrackColor: contrastColor,
              inactiveTrackColor: contrastColor.withValues(alpha: 0.3),
              trackHeight: 2.0,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
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
        _RgbValueControl(
          value: value,
          controller: controller,
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
    required this.controller,
    required this.contrastColor,
    required this.onChanged,
  });

  final int value;
  final TextEditingController controller;
  final Color contrastColor;
  final ValueChanged<int> onChanged;

  @override
  State<_RgbValueControl> createState() => _RgbValueControlState();
}

class _RgbValueControlState extends State<_RgbValueControl> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_RgbValueControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_focusNode.hasFocus) {
      widget.controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateAndUpdate();
    }
  }

  void _validateAndUpdate() {
    final parsed = int.tryParse(widget.controller.text);
    if (parsed != null) {
      final clamped = parsed.clamp(0, 255);
      widget.controller.text = clamped.toString();
      if (clamped != widget.value) {
        widget.onChanged(clamped);
      }
    } else {
      widget.controller.text = widget.value.toString();
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
            controller: widget.controller,
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
