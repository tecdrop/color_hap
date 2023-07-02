// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/app_const.dart';
import '../models/color_type.dart';
import '../screens/random_color_screen.dart';

/// Constructs the [GoRoute] for the Random Color screen.
// GoRoute buildRoute() {
//   return GoRoute(
//     path: '${AppConst.randomColorRoute}/:type',
//     builder: _routeBuilder,
//   );
// }

/// The route builder for the Random Color screen.
Widget routeBuilder(BuildContext context, GoRouterState state) {
  // Get the color type from the route parameters
  // ColorType colorType = parseColorType(state.pathParameters['type']);

  // Get the color type from the route extra
  ColorType colorType = state.extra as ColorType? ?? ColorType.mixedColor;

  // Return the Random Color screen with the provided color type
  return RandomColorScreen(
    colorType: colorType,
  );
}

/// Navigates to the Random Color screen to generate random colors of the specified type.
void go(BuildContext context, ColorType colorType) {
  // final String colorTypeString = colorTypeToString(colorType);
  // context.go('/${AppConst.randomColorRoute}/$colorTypeString');
  context.go(AppConst.randomColorRoute, extra: colorType);
}
