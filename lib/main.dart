// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'common/app_const.dart';
import 'common/app_settings.dart' as app_settings;
import 'common/ui_strings.dart';
import 'screens/color_info_screen.dart';
import 'screens/preview_color_screen.dart';
import 'screens/random_color_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // First try to load the app settings from Shared Preferences
  await Future.any([
    app_settings.loadSettings(),
    Future.delayed(const Duration(seconds: 5)),
  ]);

  // Then run the app
  runApp(const ColorHapApp());
}

/// The route configuration for the app.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    // The root route of the app is the Random Color screen
    GoRoute(
      path: AppConst.homeRoute,
      builder: (_, state) => RandomColorScreen(colorType: app_settings.colorType),
      routes: [
        // // The child route for the Random Color screen
        // GoRoute(
        //   path: '${AppConst.randomColorRoute}:type',
        //   builder: ColorInfoScreen.routeBuilder,
        // ),
        //   // The child route for the Color Information screen
        //   GoRoute(
        //     path: '${AppConst.colorInfoRoute}/:color',
        //     builder: ColorInfoScreen.routeBuilder,
        //   ),
        // The child route for the Preview Color screen
        GoRoute(
          path: '${AppConst.previewColorRoute}/:color',
          builder: PreviewColorScreen.routeBuilder,
        ),
      ],
    ),
  ],
);

/// The ColorHap main application class.
class ColorHapApp extends StatelessWidget {
  const ColorHapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: UIStrings.appName,
      debugShowCheckedModeBanner: false,

      // A black on white theme to go with the color intensive interface of the app
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: const ColorScheme.light().surface,
          onSecondary: const ColorScheme.light().onSurface,
        ),
        listTileTheme: ListTileThemeData(
          selectedTileColor: Colors.grey[300],
          selectedColor: Colors.black,
        ),
      ),

      // App routes
      // initialRoute: AppConst.randomColorRoute,
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     // The default Random Color route
      //     case AppConst.randomColorRoute:
      //       final ColorType args = settings.arguments as ColorType? ?? app_settings.colorType;
      //       app_settings.colorType = args;
      //       return MaterialPageRoute(
      //         builder: (_) => RandomColorScreen(colorType: args),
      //       );

      //     // The Color Information route
      //     case AppConst.colorInfoRoute:
      //       final RandomColor args = settings.arguments as RandomColor;
      //       return MaterialPageRoute(
      //         builder: (_) => ColorInfoScreen(
      //           randomColor: args,
      //           immersiveMode: app_settings.immersiveMode,
      //         ),
      //       );
      //   }

      //   return null; // Let onUnknownRoute handle this behavior.
      // },
    );
  }
}
