// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_settings.dart' as app_settings;
import '../models/color_type.dart';
import '../models/random_color.dart';
import '../screens/color_favorites_screen.dart';
import '../screens/color_info_screen.dart';
import '../screens/invalid_color_screen.dart';
import '../screens/random_color_screen.dart';
import '../utils/color_utils.dart' as color_utils;

/// The route configuration for the app.
final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    // The root route of the app is the Random Color screen
    GoRoute(
      path: '/',
      builder: _randomColorRouteBuilder,
      routes: [
        // The child route for the Color Info screen
        GoRoute(
          path: 'color/:colorType/:colorHex/:colorName',
          builder: _colorInfoRouteBuilder,
        ),
        GoRoute(
          path: 'fav',
          builder: _colorFavoritesRouteBuilder,
          routes: [
            // The child route for the Color Info screen
            GoRoute(
              path: 'color/:colorType/:colorHex/:colorName',
              builder: _colorInfoRouteBuilder,
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/:colorType',
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
  app_settings.colorType = parseColorType(state.pathParameters['colorType']);
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

/// The route builder for the Color Info screen.
Widget _colorInfoRouteBuilder(BuildContext context, GoRouterState state) {
  ColorType colorType = parseColorType(state.pathParameters['colorType']);
  String? colorCode = state.pathParameters['colorHex'];
  Color? color = color_utils.rgbHexToColor(colorCode);
  String? colorName = state.pathParameters['colorName'];

  // If the color code is invalid, return the Invalid Color screen
  if (color == null) {
    return InvalidColorScreen(colorCode: colorCode);
  }

  return ColorInfoScreen(
    randomColor: RandomColor(
      color: color,
      type: colorType,
      name: colorName,
    ),
  );
}

/// Navigates to the Color Info screen to show information about the specified color.
void gotoColorInfoRoute(BuildContext context, RandomColor randomColor, {bool fromFav = false}) {
  final String colorType = colorTypeToString(randomColor.type);
  final String colorCode = color_utils.toHexString(randomColor.color, withHash: false);
  // final String colorName = randomColor.name ?? '';
  context.go('${fromFav ? '/fav' : ''}/color/$colorType/$colorCode/${randomColor.name}');
  // context.go('${fromFav ? '/fav' : ''}/color/$colorType/$colorCode/$colorName');
}

// -----------------------------------------------------------------------------------------------
// Color Favorites Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Color Favorites screen.
Widget _colorFavoritesRouteBuilder(BuildContext context, GoRouterState state) {
  return const ColorFavoritesScreen();
}

/// Navigates to the Color Favorites screen to show the list of favorite colors.
void gotoColorFavoritesRoute(BuildContext context) {
  context.go('/fav');
}
