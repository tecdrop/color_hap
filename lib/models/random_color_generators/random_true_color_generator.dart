// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

/// Implements a generator of random true colors.
library;

import 'dart:math';
import 'package:flutter/material.dart';

import '../../utils/color_utils.dart' as color_utils;
import '../color_type.dart';
import '../random_color.dart';

/// Generates a random true color.
RandomColor nextRandomColor(Random random, {required Set<int> blacklist}) {
  late int randomColorCode;

  // Generate a random true color that is not in the black list (the basic, web & named colors)
  // To avoid infinite loop, let's try 1000 times, it should be more than enough because the black
  // list is less than 2K colors, while the total number of true colors is 16M.
  for (int i = 0; i < 1000; i++) {
    // Generate a random 24-bit color code, which is a number between 0x000000 and 0xFFFFFF
    randomColorCode = color_utils.withFullAlpha(random.nextInt(0xFFFFFF + 1));
    // randomColorCode = color_utils.withFullAlpha(random.nextInt(0xFF + 1));
    // randomColorCode = random.nextInt(0xFFFFFF + 1);

    // print('randomColorCode $i: $randomColorCode');
    if (i > 0) {
      print(
          '$randomColorCode: We tried $i times to generate a random true color that is not in the black list.');
    }

    if (!blacklist.contains(randomColorCode)) {
      break;
    }
  }
  // print('');

  return RandomColor(
    type: ColorType.trueColor,
    color: Color(randomColorCode),
    name: null,
    listPosition: randomColorCode,
  );
}

// /// Generates a random true color.
// RandomColor nextRandomColor(Random random) {
//   // Generate a random 24-bit color code, which is a number between 0x000000 and 0xFFFFFF
//   final int randomColorCode = random.nextInt(0xFFFFFF + 1);

//   return RandomColor(
//     type: ColorType.trueColor,
//     color: Color(color_utils.withFullAlpha(randomColorCode)),
//     name: null,
//     listPosition: randomColorCode,
//   );
// }

/// The number of available true colors that can be used to generate the random color.
///
/// This is the total number of colors can be represented in a 24-bit color palette.
int get possibilityCount => 0xFFFFFF;
