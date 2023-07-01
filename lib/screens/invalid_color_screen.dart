// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart';

/// The Invalid Color screen.
///
/// Displays an error message when an invalid color code is passed to the app.
class InvalidColorScreen extends StatelessWidget {
  /// Creates a new Invalid Color screen.
  const InvalidColorScreen({
    super.key,
    this.colorCode,
  });

  /// The color code that was invalid.
  final String? colorCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A basic app bar with the app name
      appBar: AppBar(
        title: const Text(UIStrings.appName),
      ),
      // The body of the screen displays the error message
      body: Center(
        child: Text(UIStrings.invalidColor(colorCode)),
      ),
    );
  }
}
