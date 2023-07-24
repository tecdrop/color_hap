// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Returns the light or dark theme for the app.
ThemeData getAppTheme(bool isDark) {
  return ThemeData(
    primaryColor: isDark ? Colors.white : Colors.black,
    colorScheme: isDark
        ? ColorScheme.dark(
            primary: Colors.black,
            onPrimary: Colors.white,
            secondary: const ColorScheme.dark().surface,
            onSecondary: const ColorScheme.dark().onSurface,
          )
        : ColorScheme.light(
            primary: Colors.white,
            onPrimary: Colors.black,
            secondary: const ColorScheme.light().surface,
            onSecondary: const ColorScheme.light().onSurface,
          ),
    // listTileTheme: ListTileThemeData(
    //   selectedTileColor: Colors.grey[300],
    //   selectedColor: Colors.black,
    // ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
    ),
  );
}
