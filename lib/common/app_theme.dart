// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// Returns the light or dark theme for the app.
ThemeData getAppTheme(Brightness brightness) {
  final Color backgroundColor = brightness == Brightness.dark ? Colors.black : Colors.white;
  final Color foregroundColor = brightness == Brightness.dark ? Colors.white : Colors.black;

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    drawerTheme: DrawerThemeData(
      backgroundColor: backgroundColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: backgroundColor,
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
        foregroundColor: foregroundColor,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foregroundColor,
        foregroundColor: backgroundColor,
      ),
    ),
  );
}
