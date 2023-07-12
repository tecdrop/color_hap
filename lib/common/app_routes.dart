// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_settings.dart' as app_settings;
import '../models/color_type.dart';
import '../models/random_color.dart';
import '../screens/color_info_screen.dart';
import '../screens/invalid_color_screen.dart';
import '../screens/preview_color_screen.dart';
import '../screens/random_color_screen.dart';
import '../utils/color_utils.dart';

/// The route configuration for the app.
final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    // The root route of the app is the Random Color screen
    GoRoute(
      path: '/',
      builder: _randomColorRouteBuilder,
      routes: [
        // The child route for the Color Information screen
        GoRoute(
          path: 'info/:color',
          builder: _colorInfoRouteBuilder,
        ),
        // The child route for the Preview Color screen
        GoRoute(
          path: 'preview/:color',
          builder: _previewColorRouteBuilder,
        ),
      ],
    ),
    GoRoute(
      path: '/:type',
      redirect: _randomColorRouteRedirect,
    ),
  ],
);

// -----------------------------------------------------------------------------------------------
// Random Color Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Random Color screen.
Widget _randomColorRouteBuilder(BuildContext context, GoRouterState state) {
  return RandomColorScreen(
    colorType: app_settings.colorType,
  );
}

/// The route redirect for the Random Color screen, when the color type is specified in the route.
FutureOr<String?> _randomColorRouteRedirect(BuildContext context, GoRouterState state) {
  app_settings.colorType = parseColorType(state.pathParameters['type']);
  return '/';
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
  context.go('/info/$colorCode', extra: randomColor);
}

// -----------------------------------------------------------------------------------------------
// Preview Color Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Preview Color screen.
Widget _previewColorRouteBuilder(BuildContext context, GoRouterState state) {
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
void gotoPreviewColorRoute(BuildContext context, Color color) {
  final String colorCode = ColorUtils.toHexString(color, withHash: false);
  context.go('/preview/$colorCode');
}
