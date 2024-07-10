// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../utils/color_utils.dart' as color_utils;

/// The Color Preview screen.
///
/// Displays the given [Color] in a full screen view.
class ColorPreviewScreen extends StatelessWidget {
  const ColorPreviewScreen({
    super.key,
    required this.color,
  });

  /// The color to display in the Preview screen.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: color_utils.contrastColor(color),
      ),
    );
  }
}
