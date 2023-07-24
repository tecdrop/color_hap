// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:url_launcher/link.dart';

import '../common/ui_strings.dart' as strings;

/// The Invalid screen that is displayed for invalid routes or invalid color codes.
class InvalidScreen extends StatelessWidget {
  /// Creates a new Invalid screen to display the specified error [message].
  const InvalidScreen({
    super.key,
    required this.message,
  });

  /// The error message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A basic app bar with the app name
      appBar: AppBar(
        title: const Text(strings.appName),
      ),
      // The body of the screen displays the error message
      body: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      // The floating action button takes the user back to the home screen
      floatingActionButton: Link(
        uri: Uri.parse('/'),
        builder: (BuildContext context, FollowLink? followLink) => FloatingActionButton.large(
          onPressed: followLink,
          tooltip: strings.goHome,
          child: const Icon(Icons.home),
        ),
      ),
    );
  }
}
