// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_const.dart';
import '../utils/color_utils.dart';
import 'invalid_color_screen.dart';

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

  /// The route builder for the Preview Color screen.
  static Widget routeBuilder(BuildContext context, GoRouterState state) {
    // Get the color code from the route parameters
    String? colorCode = state.pathParameters['color'];
    Color? color = ColorUtils.rgbHexToColor(colorCode);

    // If the color code is invalid, return the Invalid Color screen
    if (color == null) {
      return InvalidColorScreen(colorCode: colorCode);
    }

    // Otherwise, return the Preview Color screen with the provided color
    return PreviewColorScreen(
      color: color,
    );
  }

  /// Navigates to the Preview Color screen to show a full-screen preview of the provided color.
  static void go(BuildContext context, Color color) {
    final String colorCode = ColorUtils.toHexString(color, withHash: false);
    context.go('/${AppConst.previewColorRoute}/$colorCode');
  }

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
