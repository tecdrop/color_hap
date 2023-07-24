// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Returns the light or dark theme for the app.
ThemeData getAppTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;

  return ThemeData(
    // The color scheme used by the app
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
    textButtonTheme: TextButtonThemeData(
      // The text color of text buttons
      style: TextButton.styleFrom(
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
    ),

    // Always use the dark background snack bar theme
    snackBarTheme: SnackBarThemeData(
      // Based on https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/snack_bar.dart#L859
      backgroundColor: Color.alphaBlend(
        const ColorScheme.light().onSurface.withOpacity(0.80),
        const ColorScheme.light().surface,
      ),
      contentTextStyle: const TextStyle(color: Colors.white),
      actionTextColor: Colors.white,
    ),
  );
}
