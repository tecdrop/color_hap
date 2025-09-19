// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';

class RandomMixedColorGenerator implements RandomColorGenerator {
  final Map<ColorType, RandomColorGenerator> generators;

  RandomMixedColorGenerator(this.generators);

  @override
  ColorType get colorType => ColorType.mixedColor;

  @override
  bool contains(ColorItem color) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  ColorItem elementAt(int index) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  /// The number of possible true colors (0x000000 to 0xFFFFFF).
  @override
  int get length => 0xFFFFFF + 1;

  @override
  ColorItem next(Random random) {
    // TODO: Add logic to weight some generators more than others
    return generators.values.elementAt(random.nextInt(generators.length)).next(random);
  }
}
