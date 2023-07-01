// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

/// URLs used in the app.
class AppUrls {
  AppUrls._();

  static const String _appId = 'colorhap';
  static const String _editionId = 'aa';

  static const String setWallpaper =
      'https://play.google.com/store/apps/details?id=com.tecdrop.rgbcolorwallpaperpro&referrer=utm_source%3D$_appId%26utm_medium%3Dapp%26utm_campaign%3D${_appId}_${_editionId}_drawer';
  static const String support =
      'https://www.tecdrop.com/support/?utm_source=$_appId&utm_medium=app&utm_campaign=${_appId}_${_editionId}_drawer';
  static const String rate =
      'https://play.google.com/store/apps/details?id=com.tecdrop.colorhap&referrer=utm_source%3D$_appId%26utm_medium%3Dapp%26utm_campaign%3D${_appId}_${_editionId}_drawer';
  static const String help =
      'https://www.tecdrop.com/$_appId/?utm_source=$_appId&utm_medium=app&utm_campaign=${_appId}_${_editionId}_drawer';

  static const String viewSource = 'https://github.com/tecdrop/color_hap';

  static const String onlineSearch = 'https://www.google.com/search?q=';
}
