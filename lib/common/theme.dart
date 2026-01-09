// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// Returns the light or dark theme for the app.
ThemeData getAppTheme(Brightness brightness) {
  final backgroundColor = brightness == .dark ? Colors.black : Colors.white;
  final foregroundColor = brightness == .dark ? Colors.white : Colors.black;

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,

    // Used for app bars throughout the app
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),

    // Used for the Clear Favorites confirmation dialog
    dialogTheme: DialogThemeData(backgroundColor: backgroundColor),

    // Used for the main screen drawer
    drawerTheme: DrawerThemeData(backgroundColor: backgroundColor),

    // Used for the elevated button in the Error screen
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    ),

    // Used for the increment/decrement buttons in the RGB sliders
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foregroundColor,
        foregroundColor: backgroundColor,
      ),
    ),

    // Used for the floating action button in the main screen and Color Info screen
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),

    // Used for action bar overflow menus throughout the app
    popupMenuTheme: PopupMenuThemeData(color: backgroundColor),

    // Used for the progress indicator in the Loading screen
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: foregroundColor,
    ),

    // Used for text buttons throughout the app
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: foregroundColor),
    ),

    // Used for text selection color in the hex input field in the Edit Color Code screen
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      selectionHandleColor: Colors.grey,
    ),
  );
}
