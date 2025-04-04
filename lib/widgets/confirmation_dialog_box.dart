// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// Shows a confirmation dialog box with the specified [title] and [content].
///
/// Returns `true` if the user confirms the action, `false` otherwise.
Future<bool?> showConfirmationDialogBox(
  BuildContext context, {
  String? title,
  String? content,
  String negativeActionText = 'Cancel',
  String positiveActionText = 'Accept',
}) async {
  return await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: title != null ? Text(title) : null,
          content: content != null ? Text(content) : null,
          actions: <Widget>[
            TextButton(
              child: Text(negativeActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(positiveActionText),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
  );
}
