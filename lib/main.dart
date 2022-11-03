// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'common/app_const.dart';
import 'common/app_settings.dart';
import 'common/ui_strings.dart';
import 'models/nameable_color.dart';
import 'models/random_color.dart';
import 'screens/color_info_screen.dart';
import 'screens/random_color_screen.dart';

Future<void> main() async {
  // First try to load the app settings from Shared Preferences
  WidgetsFlutterBinding.ensureInitialized();
  await Future.any([
    AppSettings().load(),
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
            final ColorType args = settings.arguments as ColorType? ?? ColorType.webColor;
            return MaterialPageRoute(
              builder: (_) => RandomColorScreen(colorType: args),
            );

          // The Color Information route
          case AppConst.colorInfoRoute:
            final NameableColor args = settings.arguments as NameableColor;
            return MaterialPageRoute(
              builder: (_) => ColorInfoScreen(nameableColor: args),
            );
        }

        return null; // Let onUnknownRoute handle this behavior.
      },
    );
  }
}
