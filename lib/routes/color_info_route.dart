// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_const.dart';
import '../common/app_settings.dart' as app_settings;
import '../models/random_color.dart';
import '../screens/color_info_screen.dart';
import '../screens/invalid_color_screen.dart';
import '../utils/color_utils.dart';

/// Constructs the [GoRoute] for the Color Information screen.
GoRoute buildRoute() {
  return GoRoute(
    path: '${AppConst.colorInfoRoute}/:color',
    builder: _routeBuilder,
  );
}

/// The route builder for the Color Information screen.
Widget _routeBuilder(BuildContext context, GoRouterState state) {
  // Get the color code from the route parameters
  String? colorCode = state.pathParameters['color'];
  Color? color = ColorUtils.rgbHexToColor(colorCode);

  // If the color code is invalid, return the Invalid Color screen
  if (color == null) {
    return InvalidColorScreen(colorCode: colorCode);
  }

  final RandomColor? randomColor = state.extra as RandomColor?;

  // Otherwise, return the Color Information screen with the provided color, color type, optional
  // color name, and the current immersive mode setting
  return ColorInfoScreen(
    randomColor: RandomColor(
      color: color,
      type: randomColor?.type,
      name: randomColor?.name,
    ),
    immersiveMode: app_settings.immersiveMode,
  );
}

/// Navigates to the Color Information screen to show information about the provided color.
void go(BuildContext context, RandomColor randomColor) {
  final String colorCode = ColorUtils.toHexString(randomColor.color, withHash: false);

  context.go('/${AppConst.colorInfoRoute}/$colorCode', extra: randomColor);
}
