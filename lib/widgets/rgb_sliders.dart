// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/types.dart';
import '../utils/color_utils.dart' as color_utils;

/// A widget that provides RGB color adjustment controls.
///
/// Displays three sliders with increment/decrement buttons for adjusting the red, green, and blue
/// channels of a color. Each slider has a colored thumb and is accompanied by +/- buttons
/// and a text value display.
class RgbSliders extends StatefulWidget {
  const RgbSliders({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    this.layout = Axis.vertical,
  });

  /// The current color being edited.
  final Color initialColor;

  /// Callback invoked when the color changes.
  final ValueChanged<Color> onColorChanged;

  /// The layout direction for the slider controls.
  ///
  /// - [Axis.vertical]: Controls above slider (portrait mode)
  /// - [Axis.horizontal]: Controls to the right of slider (landscape mode)
  final Axis layout;

  @override
  State<RgbSliders> createState() => _RgbSlidersState();
}

class _RgbSlidersState extends State<RgbSliders> {
  /// The current color being edited.
  late Color _currentColor;

  /// Predefined colors for each RGB channel.
  static const _rgbChannelColors = <RGBChannel, Color>{
    .red: Color(0xFFFF0000),
    .green: Color(0xFF00FF00),
    .blue: Color(0xFF0000FF),
  };

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  void didUpdateWidget(RgbSliders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      _currentColor = widget.initialColor;
    }
  }

  /// Updates the specified RGB channel of the current color and notifies the parent widget.
  void _updateRGBChannel(RGBChannel channel, int value) {
    setState(() {
      _currentColor = color_utils.withRGBChannel(_currentColor, channel, value);
      widget.onColorChanged(_currentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = color_utils.contrastColor(_currentColor);

    return Column(
      mainAxisSize: .min,
      children: [
        for (final rgbChannel in RGBChannel.values) ...[
          // The slider control for each RGB channel (red, green, blue)
          _RgbSliderControl(
            value: color_utils.getRGBChannelValue(_currentColor, rgbChannel),
            layout: widget.layout,
            rgbChannelColor: _rgbChannelColors[rgbChannel]!,
            backgroundColor: _currentColor,
            contrastColor: contrastColor,
            onChanged: (value) => _updateRGBChannel(rgbChannel, value),
          ),
          if (rgbChannel != .blue) const SizedBox(height: 16.0),
        ],
      ],
    );
  }
}

/// A single RGB slider control with increment/decrement buttons and value display.
class _RgbSliderControl extends StatelessWidget {
  const _RgbSliderControl({
    required this.layout,
    required this.value,
    required this.rgbChannelColor,
    required this.backgroundColor,
    required this.contrastColor,
    required this.onChanged,
  });

  /// The current value of the RGB channel (0-255).
  final int value;

  /// The layout direction for the slider control.
  final Axis layout;

  /// The color representing the RGB channel (red, green, or blue).
  final Color rgbChannelColor;

  /// The background color where the slider is placed.
  final Color backgroundColor;

  /// The color used for text and icons to ensure contrast against the background.
  final Color contrastColor;

  /// Callback invoked when the RGB channel value changes.
  final ValueChanged<int> onChanged;

  /// Adjusts the current value by the given delta and invokes the onChanged callback.
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
        thumbColor: rgbChannelColor,
        overlayColor: rgbChannelColor.withValues(alpha: 0.1),
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
      mainAxisSize: .min,
      children: [
        // Decrement button
        _AdjustButton(
          backgroundColor: backgroundColor,
          onPressed: value > 0 ? () => _adjustValue(-1) : null,
          child: const Icon(Icons.remove),
        ),

        // Value display
        SizedBox(
          width: 42.0,
          child: Text(
            value.toString(),
            textAlign: .center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: contrastColor,
              fontWeight: .w500,
            ),
          ),
        ),

        // Increment button
        _AdjustButton(
          backgroundColor: backgroundColor,
          onPressed: value < 255 ? () => _adjustValue(1) : null,
          child: const Icon(Icons.add),
        ),
      ],
    );

    return switch (layout) {
      // Vertical layout: control above slider
      Axis.vertical => Column(
        mainAxisSize: .min,
        children: [
          control,
          const SizedBox(height: 4.0),
          sliderWidget,
        ],
      ),
      // Horizontal layout: control to the right of slider
      Axis.horizontal => Row(
        children: [
          Expanded(child: sliderWidget),
          const SizedBox(width: 4.0),
          control,
        ],
      ),
    };
  }
}

/// A circular button used for incrementing or decrementing RGB values.
class _AdjustButton extends StatelessWidget {
  const _AdjustButton({
    required this.backgroundColor,
    this.onPressed,
    required this.child,
  });

  /// The background color of the area where the button is placed.
  final Color backgroundColor;

  /// Callback invoked when the button is pressed.
  final void Function()? onPressed;

  /// The widget to display inside the button (e.g., an icon).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color_utils.getSubtleVariation(backgroundColor);
    final contrastColor = color_utils.contrastColor(backgroundColor);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: buttonColor,
        disabledBackgroundColor: buttonColor,
        disabledForegroundColor: contrastColor.withValues(alpha: 0.3),
        foregroundColor: contrastColor,
        iconSize: 20.0,
        shape: const CircleBorder(),
      ),
      child: child,
    );
  }
}
