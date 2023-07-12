// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_settings.dart' as app_settings;
import '../models/color_type.dart';
import '../models/random_color.dart';
import '../screens/color_info_screen.dart';
import '../screens/invalid_color_screen.dart';
import '../screens/random_color_screen.dart';
import '../utils/color_utils.dart';
import 'app_const.dart';

/// The route configuration for the app.
final GoRouter appRouter = GoRouter(
  // The initial route of the app is the Random Color screen
  initialLocation: '/mixed',
  routes: <RouteBase>[
    // The root route of the app is the Random Color screen
    GoRoute(
      // path: AppConst.randomColorRoute,
      path: '/:type',
      builder: _randomColorRouteBuilder,
      routes: [
        GoRoute(
          path: 'info/:color',
          builder: _colorInfoRouteBuilder,
        ),
        //   // The child route for the Color Information screen
        //   // color_info_route.buildRoute(),
        //   // The child route for the Preview Color screen
        //   // preview_color_route.buildRoute(),
      ],
    ),
    // The Color Information route
    // GoRoute(
    //   path: '/mixed/info/:color',
    //   builder: _colorInfoRouteBuilder,
    // ),
  ],
);

// -----------------------------------------------------------------------------------------------
// Random Color Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Random Color screen.
Widget _randomColorRouteBuilder(BuildContext context, GoRouterState state) {
  ColorType colorType = parseColorType(state.pathParameters['type']);
  return RandomColorScreen(
    colorType: colorType,
  );

  // Return the Random Color screen with the current color type
  // return RandomColorScreen(
  //   colorType: app_settings.colorType,
  // );
}

/// Navigates to the Random Color screen to generate random colors of the specified type.
void gotoRandomColorRoute(BuildContext context, ColorType colorType) {
  app_settings.colorType = colorType;
  context.go('/${colorTypeToString(colorType)}');
}

// -----------------------------------------------------------------------------------------------
// Color Info Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Color Information screen.
Widget _colorInfoRouteBuilder(BuildContext context, GoRouterState state) {
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
void gotoColorInfoRoute(BuildContext context, RandomColor randomColor) {
  final String colorCode = ColorUtils.toHexString(randomColor.color, withHash: false);
  final String colorType = colorTypeToString(app_settings.colorType);

  // context.go('/${AppConst.colorInfoRoute}/$colorCode', extra: randomColor);
  // context.push('/mixed/info/$colorCode', extra: randomColor);
  context.go('/$colorType/info/$colorCode', extra: randomColor);
}
