// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_const.dart';
import '../screens/invalid_color_screen.dart';
import '../screens/preview_color_screen.dart';
import '../utils/color_utils.dart';

/// Constructs the [GoRoute] for the Color Information screen.
GoRoute buildRoute() {
  return GoRoute(
    path: '${AppConst.previewColorRoute}/:color',
    builder: _routeBuilder,
  );
}

/// The route builder for the Preview Color screen.
Widget _routeBuilder(BuildContext context, GoRouterState state) {
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
void go(BuildContext context, Color color) {
  final String colorCode = ColorUtils.toHexString(color, withHash: false);
  context.go('/${AppConst.previewColorRoute}/$colorCode');
}
