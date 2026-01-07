// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Various utility functions.
library;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import '../common/strings.dart' as strings;

/// Formats the given integer value to a string with thousands separators.
///
/// The separators are spaces, as per the ISU standard.
String intToCommaSeparatedString(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]} ',
  );
}

/// Navigates to the specified [screen] and returns the result.
Future<T?> navigateTo<T>(BuildContext context, Widget screen) async {
  return await navigatorTo<T>(Navigator.of(context), screen);
}

/// Navigates to the specified [screen] and returns the result.
Future<T?> navigatorTo<T>(NavigatorState navigator, Widget screen) async {
  return await navigator.push(MaterialPageRoute<T>(builder: (context) => screen));
}

/// Shows a [SnackBar] with the specified [text] across all registered [Scaffold]s.
void showSnackBarForAsync(ScaffoldMessengerState messengerState, String text) {
  final snackBar = SnackBar(content: Text(text));
  messengerState
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Stores the given text on the clipboard, and shows a [SnackBar] on success and on failure.
Future<void> copyToClipboard(BuildContext context, String value) async {
  final messengerState = ScaffoldMessenger.of(context);
  try {
    await Clipboard.setData(ClipboardData(text: value));
    showSnackBarForAsync(messengerState, strings.copiedSnack(value));
  } on Exception catch (e) {
    if (kDebugMode) debugPrint('Failed to copy to clipboard: $e');
    showSnackBarForAsync(messengerState, strings.copiedErrorSnack(value));
  }
}

/// Launches the specified [URL] in the mobile platform, using the default external application.
Future<bool> launchUrlExternal(String url) async {
  return await launchUrl(Uri.parse(url), mode: .externalApplication);
}
