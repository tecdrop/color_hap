// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

/// The Preview Color screen.
///
/// Displays a full-screen preview of the provided color.
class PreviewColorScreen extends StatelessWidget {
  /// Creates a new Preview Color screen.
  const PreviewColorScreen({
    super.key,
    required this.color,
  });

  /// The color to preview.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Color contrastBWColor = ColorUtils.contrastOf(color);

    return Scaffold(
      backgroundColor: color,

      // A basic app bar that blends in with the rest of the screen, with just a Back icon button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: contrastBWColor,
        elevation: 0.0,
      ),
    );
  }
}
