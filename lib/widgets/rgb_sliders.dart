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
  /// The current RGB component values.
  late Map<RgbComponent, int> _values;

  /// The text controllers for each RGB component.
  late final Map<RgbComponent, TextEditingController> _controllers;

  /// The focus nodes for each RGB component.
  late final Map<RgbComponent, FocusNode> _focusNodes;

  /// The colors for each RGB component.
  static const _componentColors = <RgbComponent, Color>{
    .red: Color(0xFFFF0000),
    .green: Color(0xFF00FF00),
    .blue: Color(0xFF0000FF),
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

  /// Updates the internal RGB values from the given color.
  void _updateFromColor(Color color) {
    _values = {
      .red: (color.r * 255).round(),
      .green: (color.g * 255).round(),
      .blue: (color.b * 255).round(),
    };
  }

  /// Notifies the parent widget of a color change.
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

  /// Updates a specific RGB component value.
  void _updateComponent(RgbComponent component, int value) {
    setState(() {
      _values[component] = value.clamp(0, 255);
      _notifyColorChange();
    });
  }

  /// Handles focus changes for text fields to validate input.
  void _onFocusChange(RgbComponent component) {
    if (!_focusNodes[component]!.hasFocus) {
      _validateAndUpdate(component);
    }
  }

  /// Validates and updates the RGB component value from the text field.
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
      padding: const .all(16.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          for (final component in RgbComponent.values) ...[
            Row(
              children: [
                Expanded(
                  // The RGB slider
                  child: _RgbSlider(
                    value: _values[component]!,
                    color: _componentColors[component]!,
                    contrastColor: widget.contrastColor,
                    onChanged: (value) => _updateComponent(component, value),
                  ),
                ),

                // The value control with +/- buttons and text field
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
            if (component != .blue) const SizedBox(height: 16.0),
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

  /// The current RGB component value (0-255).
  final int value;

  /// The color of the slider track and thumb.
  final Color color;

  /// The contrast color for UI elements (black or white based on background).
  final Color contrastColor;

  /// Callback invoked when the value changes.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      // Customize the slider appearance
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
      // The slider itself
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

  /// The current RGB component value (0-255).
  final int value;

  /// The text controller for the value input field.
  final TextEditingController controller;

  /// The focus node for the value input field.
  final FocusNode focusNode;

  /// The contrast color for UI elements (black or white based on background).
  final Color contrastColor;

  /// Callback invoked when the value changes.
  final ValueChanged<int> onChanged;

  /// Callback invoked when the value is submitted.
  final VoidCallback onSubmitted;

  /// Adjusts the value by the given delta and invokes the onChanged callback.
  void _adjustValue(int delta) {
    final newValue = (value + delta).clamp(0, 255);
    if (newValue != value) {
      onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        // The decrement button
        IconButton(
          color: contrastColor,
          disabledColor: contrastColor.withValues(alpha: 0.3),
          iconSize: 20.0,
          onPressed: value > 0 ? () => _adjustValue(-1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 56.0,

          // The text field for direct value input
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: .number,
            textAlign: .center,
            style: TextStyle(color: contrastColor),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const .symmetric(vertical: 8.0),
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

        // The increment button
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
