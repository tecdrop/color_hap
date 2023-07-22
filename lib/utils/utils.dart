// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/ui_strings.dart';

/// Various static utility functions.
class Utils {
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern();

  /// Formats the given integer value to a string with thousands separators.
  static String intToCommaSeparatedString(int value) {
    return _numberFormat.format(value);
  }

  /// Shows a [SnackBar] with the specified [text] across all registered [Scaffold]s.
  static void showSnackBar(BuildContext context, String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Shows a [SnackBar] with the specified [text] across all registered [Scaffold]s.
  static void showSnackBarForAsync(ScaffoldMessengerState messengerState, String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    messengerState
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Stores the given text on the clipboard, and shows a [SnackBar] on success and on failure.
  static Future<void> copyToClipboard(BuildContext context, String value) async {
    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
    try {
      await Clipboard.setData(ClipboardData(text: value));
      Utils.showSnackBarForAsync(messengerState, UIStrings.copiedSnack(value));
    } catch (error) {
      Utils.showSnackBarForAsync(messengerState, UIStrings.copiedErrorSnack(value));
    }
  }

  /// Launches the specified [URL] in the mobile platform, using the default external application.
  ///
  /// Shows an error [SnackBar] if there is no support for launching the URL.
  static Future<void> launchUrlExternal(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      Utils.showSnackBar(context, 'Failed to open $url');
    }
  }
}
