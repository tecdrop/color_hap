// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import 'common/app_settings.dart' as settings;
import 'common/app_theme.dart';
import 'common/ui_strings.dart' as strings;
import 'screens/random_color_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // First try to load the app settings from Shared Preferences
  await Future.any([
    settings.loadSettings(),
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
      title: strings.appName,
      debugShowCheckedModeBanner: false,

      // A black on white theme to go with the color intensive interface of the app
      theme: getAppTheme(Brightness.light),

      // On dark mode, use a white on black theme
      darkTheme: getAppTheme(Brightness.dark),

      home: const RandomColorScreen(),
    );
  }
}
