// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// RGB color component (red, green, or blue).
enum RgbComponent { red, green, blue }

/// A widget that provides RGB color adjustment controls.
///
/// Displays three sliders with increment/decrement buttons for adjusting the red, green, and blue
/// components of a color. Each slider has a colored thumb and is accompanied by +/- buttons
/// and a text value display.
class RgbSliders extends StatefulWidget {
  const RgbSliders({
    super.key,
    required this.color,
    required this.onColorChanged,
    required this.contrastColor,
    this.layout = Axis.vertical,
  });

  /// The current color being edited.
  final Color color;

  /// Callback invoked when the color changes.
  final ValueChanged<Color> onColorChanged;

  /// The contrast color for UI elements (black or white based on background).
  final Color contrastColor;

  /// The layout direction for the slider controls.
  ///
  /// - [Axis.vertical]: Controls above slider (portrait mode)
  /// - [Axis.horizontal]: Controls to the right of slider (landscape mode)
  final Axis layout;

  @override
  State<RgbSliders> createState() => _RgbSlidersState();
}

class _RgbSlidersState extends State<RgbSliders> {
  late Map<RgbComponent, int> _values;

  static const _componentColors = {
    RgbComponent.red: Color(0xFFFF0000),
    RgbComponent.green: Color(0xFF00FF00),
    RgbComponent.blue: Color(0xFF0000FF),
  };

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final component in RgbComponent.values) ...[
            _RgbSliderControl(
              layout: widget.layout,
              value: _values[component]!,
              color: _componentColors[component]!,
              contrastColor: widget.contrastColor,
              onChanged: (value) => _updateComponent(component, value),
            ),
            if (component != RgbComponent.blue) const SizedBox(height: 16.0),
          ],
        ],
      ),
    );
  }
}

/// A single RGB slider control with increment/decrement buttons and value display.
class _RgbSliderControl extends StatelessWidget {
  const _RgbSliderControl({
    required this.layout,
    required this.value,
    required this.color,
    required this.contrastColor,
    required this.onChanged,
  });

  final Axis layout;
  final int value;
  final Color color;
  final Color contrastColor;
  final ValueChanged<int> onChanged;

  void _adjustValue(int delta) {
    final newValue = (value + delta).clamp(0, 255);
    if (newValue != value) {
      onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the slider widget
    final sliderWidget = SliderTheme(
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

    // Build the value control (buttons + text)
    final control = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrement button
        _AdjustButton(
          iconData: Icons.remove,
          color: contrastColor,
          onPressed: value > 0 ? () => _adjustValue(-1) : null,
        ),

        // Value display
        SizedBox(
          width: 42.0,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: contrastColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // const SizedBox(width: 8.0),

        // Increment button
        _AdjustButton(
          iconData: Icons.add,
          color: contrastColor,
          onPressed: value < 255 ? () => _adjustValue(1) : null,
        ),
      ],
    );

    // Layout based on axis
    return layout == Axis.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              control,
              const SizedBox(height: 4.0),
              sliderWidget,
            ],
          )
        : Row(
            children: [
              Expanded(child: sliderWidget),
              const SizedBox(width: 8.0),
              control,
            ],
          );
  }
}

/// A circular button used for incrementing or decrementing RGB values.
class _AdjustButton extends StatelessWidget {
  const _AdjustButton({
    super.key, // ignore: unused_element_parameter
    required this.iconData,
    required this.color,
    this.onPressed,
  });

  /// The icon to display inside the button.
  final IconData iconData;

  /// The color of the button.
  final Color color;

  /// Callback invoked when the button is pressed.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color.withValues(alpha: 0.075);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: backgroundColor,
        foregroundColor: color,
        shape: const CircleBorder(),
      ),
      child: Icon(iconData, size: 20),
    );
  }
}
