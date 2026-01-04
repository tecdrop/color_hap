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
    drawerTheme: DrawerThemeData(backgroundColor: backgroundColor),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),
    bottomAppBarTheme: BottomAppBarThemeData(color: backgroundColor),
    popupMenuTheme: PopupMenuThemeData(color: backgroundColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),
    dialogTheme: DialogThemeData(backgroundColor: backgroundColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: foregroundColor),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foregroundColor,
        foregroundColor: backgroundColor,
      ),
    ),

    // Text selection colors - used in text fields such as the hex input
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      selectionHandleColor: Colors.grey,
    ),
  );
}
