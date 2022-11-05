// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'common/app_const.dart';
import 'common/app_settings.dart' as app_settings;
import 'common/ui_strings.dart';
import 'models/random_color.dart';
import 'screens/color_info_screen.dart';
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

/// The ColorHap main application class.
class ColorHapApp extends StatelessWidget {
  const ColorHapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: AppConst.randomColorRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {

          // The default Random Color route
          case AppConst.randomColorRoute:
            final ColorType args = settings.arguments as ColorType? ?? app_settings.colorType;
            app_settings.colorType = args;
            return MaterialPageRoute(
              builder: (_) => RandomColorScreen(colorType: args),
            );

          // The Color Information route
          case AppConst.colorInfoRoute:
            final RandomColor args = settings.arguments as RandomColor;
            return MaterialPageRoute(
              builder: (_) => ColorInfoScreen(
                randomColor: args,
                immersiveMode: app_settings.immersiveMode,
              ),
            );
        }

        return null; // Let onUnknownRoute handle this behavior.
      },
    );
  }
}
