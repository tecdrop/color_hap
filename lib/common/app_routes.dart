// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_const.dart' as consts;
import '../common/ui_strings.dart' as strings;
import '../models/color_type.dart';
import '../models/random_color.dart';
import '../screens/color_favorites_screen.dart';
import '../screens/color_info_screen.dart';
import '../screens/color_preview_screen.dart';
import '../screens/invalid_screen.dart';
import '../screens/random_color_screen.dart';
import '../utils/color_utils.dart' as color_utils;

/// The route configuration for the app.
final GoRouter appRouter = GoRouter(
  // The error handler redirects to the Invalid screen
  onException: (_, GoRouterState state, GoRouter router) {
    router.go('/404', extra: state.uri.toString());
  },

  // The routes configuration
  routes: <RouteBase>[
    // The home route of the app is the Random Color screen
    GoRoute(
      path: '/',
      builder: _randomColorRouteBuilder,
      routes: [
        // The child route for the Color Info screen
        GoRoute(
          path: 'color/:colorType/:colorHex/:colorName',
          builder: _colorInfoRouteBuilder,
        ),

        // The child route for the Color Preview screen
        GoRoute(
          path: 'preview/:colorHex',
          builder: _colorPreviewRouteBuilder,
        ),

        // The child route for the Favorite Colors screen
        GoRoute(
          path: 'fav',
          builder: _colorFavoritesRouteBuilder,
          routes: [
            // The child route for the Color Info screen (from the Favorite Colors screen)
            GoRoute(
              path: 'color/:colorType/:colorHex/:colorName',
              builder: _colorInfoRouteBuilder,
            ),
          ],
        ),
      ],
    ),

    // The route for the Invalid screen, when the route is invalid
    GoRoute(
      path: '/404',
      builder: (BuildContext context, GoRouterState state) {
        return InvalidScreen(message: strings.invalidPage(state.extra as String?));
      },
    ),
  ],
);

// -----------------------------------------------------------------------------------------------
// Random Color Route (Home)
// -----------------------------------------------------------------------------------------------

/// The route builder for the Random Color screen, which is the home screen of the app.
Widget _randomColorRouteBuilder(BuildContext context, GoRouterState state) {
  return const RandomColorScreen();
}

// -----------------------------------------------------------------------------------------------
// Color Info Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Color Info screen.
Widget _colorInfoRouteBuilder(BuildContext context, GoRouterState state) {
  ColorType colorType = ColorType.fromShortString(state.pathParameters['colorType']);
  String? colorCode = state.pathParameters['colorHex'];
  Color? color = color_utils.rgbHexToColor(colorCode);
  String? colorName = state.pathParameters['colorName'];

  // If the color code is invalid, return the Invalid Color screen
  if (color == null) {
    return InvalidScreen(message: strings.invalidColor(colorCode));
  }

  return ColorInfoScreen(
    randomColor: RandomColor(
      color: color,
      type: colorType,
      name: colorName != consts.noNameColorParam ? colorName : null,
    ),
  );
}

/// Navigates to the Color Info screen to show information about the specified color.
void gotoColorInfoRoute(BuildContext context, RandomColor randomColor, {bool fromFav = false}) {
  final String colorType = randomColor.type.toShortString();
  final String colorCode = color_utils.toHexString(randomColor.color, withHash: false);
  final String colorName = randomColor.name ?? consts.noNameColorParam;
  context.go('${fromFav ? '/fav' : ''}/color/$colorType/$colorCode/$colorName');
}

// -----------------------------------------------------------------------------------------------
// Color Preview Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Color Preview screen.
Widget _colorPreviewRouteBuilder(BuildContext context, GoRouterState state) {
  String? colorCode = state.pathParameters['colorHex'];
  Color? color = color_utils.rgbHexToColor(colorCode);

  // If the color code is invalid, return the Invalid Color screen
  if (color == null) {
    return InvalidScreen(message: strings.invalidColor(colorCode));
  }

  return ColorPreviewScreen(color: color);
}

/// Navigates to the Color Preview screen to show the specified color.
Future<void> gotoColorPreviewRoute(BuildContext context, Color color) async {
  final String colorCode = color_utils.toHexString(color, withHash: false);
  return await context.push<void>('/preview/$colorCode');
}

// -----------------------------------------------------------------------------------------------
// Color Favorites Route
// -----------------------------------------------------------------------------------------------

/// The route builder for the Color Favorites screen.
Widget _colorFavoritesRouteBuilder(BuildContext context, GoRouterState state) {
  return const ColorFavoritesScreen();
}

/// Navigates to the Color Favorites screen to show the list of favorite colors.
Future<void> gotoColorFavoritesRoute(BuildContext context) async {
  return await context.push<void>('/fav');
}
