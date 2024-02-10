// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;

/// A widget that displays a random color.
///
/// It fills the widget with the specified color, and displays the color hex code and optional name.
/// It also animates the color change.
class RandomColorDisplay extends StatelessWidget {
  const RandomColorDisplay({
    super.key,
    required this.randomColor,
  });

  /// The random color to display.
  final RandomColor randomColor;

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = color_utils.contrastColor(randomColor.color);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? hexTestStyle =
        randomColor.name != null ? textTheme.titleMedium : textTheme.headlineMedium;

    // Use an animated container to animate the color change
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      color: randomColor.color,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the color hex code
          Text(
            color_utils.toHexString(randomColor.color),
            style: hexTestStyle?.copyWith(color: contrastColor),
            textAlign: TextAlign.center,
          ),
          // Display the color name if it is not null
          if (randomColor.name != null)
            Text(
              randomColor.name!,
              style: textTheme.headlineMedium?.copyWith(color: contrastColor),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
