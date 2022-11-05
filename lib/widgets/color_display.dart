// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/random_color.dart';
import '../utils/color_utils.dart';

/// A widget that displays the hex code and optional name of a random color.
class ColorDisplay extends StatelessWidget {
  const ColorDisplay({super.key, required this.randomColor});

  /// The random color to display.
  final RandomColor randomColor;

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = ColorUtils.contrastOf(randomColor.color);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? hexTestStyle =
        randomColor.name != null ? textTheme.titleMedium : textTheme.headlineMedium;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ColorUtils.toHexString(randomColor.color),
            style: hexTestStyle?.copyWith(color: contrastColor),
            textAlign: TextAlign.center,
          ),
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
