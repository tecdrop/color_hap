// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/nameable_color.dart';
import '../utils/color_utils.dart';

/// A widget that displays the hex code and optional name of a nameable color.
class ColorDisplay extends StatelessWidget {
  const ColorDisplay({super.key, required this.nameableColor});

  /// The nameable color to display.
  final NameableColor nameableColor;

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = ColorUtils.contrastOf(nameableColor.color);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? hexTestStyle =
        nameableColor.name != null ? textTheme.titleMedium : textTheme.headlineMedium;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ColorUtils.toHexString(nameableColor.color),
            style: hexTestStyle?.copyWith(color: contrastColor),
            textAlign: TextAlign.center,
          ),
          if (nameableColor.name != null)
            Text(
              nameableColor.name!,
              style: textTheme.headlineMedium?.copyWith(color: contrastColor),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
