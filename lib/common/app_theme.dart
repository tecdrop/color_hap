// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Returns the light or dark theme for the app.
ThemeData getAppTheme(Brightness brightness) {
  final Color backgroundColor = brightness == Brightness.dark ? Colors.black : Colors.white;
  final Color foregroundColor = brightness == Brightness.dark ? Colors.white : Colors.black;

  return ThemeData(
    brightness: brightness,
    drawerTheme: DrawerThemeData(
      backgroundColor: backgroundColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: backgroundColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: backgroundColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
    ),
  );
}
