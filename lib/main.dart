// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'common/app_routes.dart';
import 'common/app_settings.dart' as app_settings;
import 'common/ui_strings.dart';

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
    return MaterialApp.router(
      routerConfig: appRouter,
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
    );
  }
}
