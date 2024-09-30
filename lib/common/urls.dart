// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

/// URLs used in the app.
library;

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// The URL for the "Set Wallpaper" drawer item.
const String setWallpaper =
    'https://play.google.com/store/apps/details?id=com.tecdrop.rgbcolorwallpaperpro&referrer=utm_source%3Dcolorhap%26utm_medium%3Dapp%26utm_campaign%3Dcolorhap_app_drawer';

/// The URL for the app's help page.
const String help =
    'https://www.tecdrop.com/colorhap/help/?utm_source=colorhap&utm_medium=app&utm_campaign=colorhap_app_drawer';

/// The URL for the app's source code.
const String viewSource = 'https://github.com/tecdrop/color_hap';

/// The URL to search for a color on the web (currently Google).
const String onlineSearch = 'https://www.google.com/search?q=';

/// The URL to search for a color on the web (currently Google).
String aboutTheseColors(String listId) =>
    'https://www.tecdrop.com/colorhap/help/colors/$listId/?utm_source=colorhap&utm_medium=app&utm_campaign=colorhap_app_about_these_colors';

/// The URL that allows the user to rate the ColorHap web app.
const String _webRateUrl = 'https://go.tecdrop.com/colorhap/app/rate/web/';

/// The URL that allows the user to rate the ColorHap Android app (Google Play Store).
const String _androidRateUrl =
    'https://play.google.com/store/apps/details?id=com.tecdrop.colorhap&referrer=utm_source%3Dcolorhap%26utm_medium%3Dapp%26utm_campaign%3Dcolorhap_app_drawer';

/// Get the URL that allows the user to rate the app based on the platform.
String getRateUrl() {
  if (kIsWeb) {
    return _webRateUrl;
  }

  if (Platform.isAndroid) {
    return _androidRateUrl;
  }

  // We should not reach here, but return the web URL as a fallback
  return _webRateUrl;
}
