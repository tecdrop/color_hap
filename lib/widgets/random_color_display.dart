// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../models/color_item.dart';
import '../utils/color_utils.dart' as color_utils;
import 'color_info_display.dart';

/// A widget that displays a random color.
///
/// It fills the widget with the specified color, and displays the color hex code and optional name.
/// It also animates the color change.
class RandomColorDisplay extends StatelessWidget {
  const RandomColorDisplay({
    super.key,
    required this.colorItem,
    this.onDoubleTap,
    this.onLongPress,
  });

  /// The random color to display.
  final ColorItem colorItem;

  /// The function to call when the user double-taps the color hex code and name.
  final void Function()? onDoubleTap;

  /// The function to call when the user long-presses the color hex code and name.
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final contrastColor = color_utils.contrastColor(colorItem.color);

    // Use an animated container to animate the color change
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      color: colorItem.color,
      width: .infinity,
      height: .infinity,
      alignment: .center,
      padding: const .all(16.0),
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: ColorInfoDisplay(
          colorItem: colorItem,
          contrastColor: contrastColor,
          showType: false,
          size: .large,
          centered: true,
        ),
      ),
    );
  }
}
