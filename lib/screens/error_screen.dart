// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;

/// A screen that displays an error message with an optional retry button.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.message,
    this.onRetry,
  });

  /// The error message to display.
  final String message;

  /// The callback that is called when the retry button is pressed.
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,

      // A basic app bar with just the "Error" title
      appBar: AppBar(title: const Text(strings.errorScreenTitle)),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            // The error icon and message
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry button if a retry callback is provided
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text(strings.retryButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
