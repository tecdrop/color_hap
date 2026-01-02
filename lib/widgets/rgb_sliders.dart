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
  late Map<RgbComponent, int> _values;
  late final Map<RgbComponent, TextEditingController> _controllers;
  late final Map<RgbComponent, FocusNode> _focusNodes;

  static const _componentColors = {
    RgbComponent.red: Color(0xFFFF0000),
    RgbComponent.green: Color(0xFF00FF00),
    RgbComponent.blue: Color(0xFF0000FF),
  };

  @override
  void initState() {
    super.initState();
    _updateFromColor(widget.color);

    // Create controllers and focus nodes
    _controllers = {
      for (final component in RgbComponent.values)
        component: TextEditingController(text: _values[component].toString()),
    };

    _focusNodes = {
      for (final component in RgbComponent.values) component: FocusNode(),
    };

    // Add focus listeners for validation
    for (final entry in _focusNodes.entries) {
      entry.value.addListener(() => _onFocusChange(entry.key));
    }
  }

  @override
  void didUpdateWidget(RgbSliders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _updateFromColor(widget.color);
      // Update controller texts only if not focused
      for (final component in RgbComponent.values) {
        if (!_focusNodes[component]!.hasFocus) {
          _controllers[component]!.text = _values[component].toString();
        }
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _updateFromColor(Color color) {
    _values = {
      RgbComponent.red: (color.r * 255).round(),
      RgbComponent.green: (color.g * 255).round(),
      RgbComponent.blue: (color.b * 255).round(),
    };
  }

  void _notifyColorChange() {
    widget.onColorChanged(
      Color.fromARGB(
        255,
        _values[RgbComponent.red]!,
        _values[RgbComponent.green]!,
        _values[RgbComponent.blue]!,
      ),
    );
  }

  void _updateComponent(RgbComponent component, int value) {
    setState(() {
      _values[component] = value.clamp(0, 255);
      _notifyColorChange();
    });
  }

  void _onFocusChange(RgbComponent component) {
    if (!_focusNodes[component]!.hasFocus) {
      _validateAndUpdate(component);
    }
  }

  void _validateAndUpdate(RgbComponent component) {
    final controller = _controllers[component]!;
    final parsed = int.tryParse(controller.text);
    if (parsed != null) {
      final clamped = parsed.clamp(0, 255);
      controller.text = clamped.toString();
      if (clamped != _values[component]!) {
        _updateComponent(component, clamped);
      }
    } else {
      controller.text = _values[component].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final component in RgbComponent.values) ...[
            Row(
              children: [
                Expanded(
                  child: _RgbSlider(
                    value: _values[component]!,
                    color: _componentColors[component]!,
                    contrastColor: widget.contrastColor,
                    onChanged: (value) => _updateComponent(component, value),
                  ),
                ),
                _RgbValueControl(
                  value: _values[component]!,
                  controller: _controllers[component]!,
                  focusNode: _focusNodes[component]!,
                  contrastColor: widget.contrastColor,
                  onChanged: (value) => _updateComponent(component, value),
                  onSubmitted: () => _validateAndUpdate(component),
                ),
              ],
            ),
            if (component != RgbComponent.blue) const SizedBox(height: 16.0),
          ],
        ],
      ),
    );
  }
}

/// A single RGB slider widget.
class _RgbSlider extends StatelessWidget {
  const _RgbSlider({
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
    return SliderTheme(
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
    );
  }
}

/// Value control with +/- buttons and text field.
class _RgbValueControl extends StatelessWidget {
  const _RgbValueControl({
    required this.value,
    required this.controller,
    required this.focusNode,
    required this.contrastColor,
    required this.onChanged,
    required this.onSubmitted,
  });

  final int value;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color contrastColor;
  final ValueChanged<int> onChanged;
  final VoidCallback onSubmitted;

  void _adjustValue(int delta) {
    final newValue = (value + delta).clamp(0, 255);
    if (newValue != value) {
      onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          color: contrastColor,
          disabledColor: contrastColor.withValues(alpha: 0.3),
          iconSize: 20.0,
          onPressed: value > 0 ? () => _adjustValue(-1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 56.0,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(color: contrastColor),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: contrastColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: contrastColor.withValues(alpha: 0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: contrastColor),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            onSubmitted: (_) => onSubmitted(),
          ),
        ),
        IconButton(
          color: contrastColor,
          disabledColor: contrastColor.withValues(alpha: 0.3),
          iconSize: 20.0,
          onPressed: value < 255 ? () => _adjustValue(1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
