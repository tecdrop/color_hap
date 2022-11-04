// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

/// The persistent app settings singleton class.
class AppSettings {
  // -----------------------------------------------------------------------------------------------
  // Singleton
  // -----------------------------------------------------------------------------------------------

  factory AppSettings() {
    return _singleton;
  }

  AppSettings._internal();

  static final AppSettings _singleton = AppSettings._internal();

  // -----------------------------------------------------------------------------------------------
  // fullScreenMode setting
  // -----------------------------------------------------------------------------------------------

  static const String _fullScreenModeKey = 'fullScreenMode';

  bool _fullScreenMode = false;

  /// Whether the main screens are in fullscreen mode.
  bool get fullScreenMode => _fullScreenMode;
  set fullScreenMode(bool value) {
    _fullScreenMode = value;
    _saveFullScreenMode();
  }

  /// Saves the fullscreen mode setting to persistent storage.
  Future<void> _saveFullScreenMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_fullScreenModeKey, _fullScreenMode);
  }

  // -----------------------------------------------------------------------------------------------
  // Common
  // -----------------------------------------------------------------------------------------------

  /// Loads app settings from persistent storage.
  Future<void> load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fullScreenMode = preferences.getBool(_fullScreenModeKey) ?? false;
  }
}
