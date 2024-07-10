// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'common/app_routes.dart';
import 'common/app_settings.dart' as settings;
import 'common/app_theme.dart';
import 'common/ui_strings.dart' as strings;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // First try to load the app settings from Shared Preferences
  await Future.any([
    settings.loadSettings(),
    Future.delayed(const Duration(seconds: 5)),
  ]);

  // Make imperative APIs (e.g. push) reflect in the browser URL
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Then run the app
  runApp(const ColorHapApp());
}

/// The ColorHap main application class.
class ColorHapApp extends StatelessWidget {
  const ColorHapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: strings.appName,
      debugShowCheckedModeBanner: false,

      // The app routes configuration
      routerConfig: appRouter,

      // A black on white theme to go with the color intensive interface of the app
      theme: getAppTheme(Brightness.light),

      // On dark mode, use a white on black theme
      darkTheme: getAppTheme(Brightness.dark),
    );
  }
}
