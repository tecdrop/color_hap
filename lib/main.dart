// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import 'common/preferences.dart' as preferences;
import 'common/strings.dart' as strings;
import 'common/theme.dart';
import 'screens/random_color_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // First try to load the app settings from Shared Preferences
  await Future.any([
    preferences.loadSettings(),
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
      theme: getAppTheme(.light),

      // On dark mode, use a white on black theme
      darkTheme: getAppTheme(.dark),

      home: const RandomColorScreen(),
    );
  }
}
