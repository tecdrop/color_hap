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
  /// Current RGB component values (0-255).
  late Map<RgbComponent, int> _values;

  /// Text controllers for the RGB component value input fields.
  late final Map<RgbComponent, TextEditingController> _controllers;

  /// Predefined colors for each RGB component.
  static const _componentColors = {
    RgbComponent.red: Color(0xFFFF0000),
    RgbComponent.green: Color(0xFF00FF00),
    RgbComponent.blue: Color(0xFF0000FF),
  };

  @override
  void initState() {
    super.initState();
    _updateFromColor(widget.color);

    // Create controllers based on current values
    _controllers = {
      for (final component in RgbComponent.values)
        component: TextEditingController(text: _values[component].toString()),
    };
  }

  @override
  void didUpdateWidget(RgbSliders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _updateFromColor(widget.color);
      // Update all controller texts
      for (final component in RgbComponent.values) {
        _controllers[component]!.text = _values[component].toString();
      }
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

  /// Update internal RGB values from the given color.
  void _updateFromColor(Color color) {
    _values = {
      RgbComponent.red: (color.r * 255).round(),
      RgbComponent.green: (color.g * 255).round(),
      RgbComponent.blue: (color.b * 255).round(),
    };
  }

  /// Notify the parent widget of the color change.
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

  /// Get the current value of the specified RGB component.
  int _getValue(RgbComponent component) => _values[component]!;

  /// Update the specified RGB component with a new value.
  void _updateComponent(RgbComponent component, int value) {
    setState(() {
      _values[component] = value.clamp(0, 255);
      _notifyColorChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16.0),
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

  /// The RGB component this slider row controls.
  final RgbComponent component;

  /// The current value of the component (0-255).
  final int value;

  /// The text controller for the value input field.
  final TextEditingController controller;

  /// The color of the slider track.
  final Color color;

  /// The contrast color for UI elements.
  final Color contrastColor;

  /// Callback invoked when the component value changes.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
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

            // The slider for adjusting the RGB component value
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 255,
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
          ),
        ),

        // The value control with +/- buttons and text field
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

  /// The current value of the RGB component (0-255).
  final int value;

  /// The text controller for the value input field.
  final TextEditingController controller;

  /// The contrast color for UI elements.
  final Color contrastColor;

  /// Callback invoked when the component value changes.
  final ValueChanged<int> onChanged;

  @override
  State<_RgbValueControl> createState() => _RgbValueControlState();
}

class _RgbValueControlState extends State<_RgbValueControl> {
  /// Focus node to monitor text field focus changes.
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

  /// Handle focus changes to validate input when focus is lost.
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

  /// Decrement the value by 1 and notify the change.
  void _decrement() {
    if (widget.value > 0) {
      widget.onChanged(widget.value - 1);
    }
  }

  /// Increment the value by 1 and notify the change.
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
        // The decrement button
        IconButton(
          color: widget.contrastColor,
          iconSize: 20.0,
          onPressed: widget.value > 0 ? _decrement : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 56.0,

          // The text field for direct value input
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: .number,
            textAlign: .center,
            style: TextStyle(color: widget.contrastColor),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const .symmetric(vertical: 8.0),
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

        // The increment button
        IconButton(
          color: widget.contrastColor,
          iconSize: 20.0,
          onPressed: widget.value < 255 ? _increment : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
