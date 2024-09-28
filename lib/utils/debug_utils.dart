// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:ui';
import 'package:flutter/foundation.dart';

import '../models/more.dart';
import '../models/random_color_generators/random_attractive_color_generator.dart' as racg;
import '../models/random_color_generators/random_basic_color_generator.dart' as rbcg;
import '../models/random_color_generators/random_named_color_generator.dart' as rncg;
import '../models/random_color_generators/random_web_color_generator.dart' as rwcg;
import 'color_utils.dart' as color_utils;

/// Checks if there are any colors in the kAttractiveColors that are also in one of the basic, web,
/// or named colors lists.
void checkForDuplicateAttractiveColors() {
  if (!kDebugMode) return;

  final Set<int> basicColorCodes = rbcg.kBasicColors.map((ColorWithName item) => item.code).toSet();
  final Set<int> webColorCodes = rwcg.kWebColors.map((ColorWithName item) => item.code).toSet();
  final Set<int> namedColorCodes = rncg.kNamedColors.map((ColorWithName item) => item.code).toSet();

  for (final int colorCode in racg.kAttractiveColors) {
    if (basicColorCodes.contains(colorCode) ||
        webColorCodes.contains(colorCode) ||
        namedColorCodes.contains(colorCode)) {
      final String hexString = color_utils.toHexString(Color(colorCode), withHash: false);
      print(
        'WARNING: The attractive color 0XFF$hexString is also in one of the basic, web, or named colors lists.',
      );
    }
  }
}
