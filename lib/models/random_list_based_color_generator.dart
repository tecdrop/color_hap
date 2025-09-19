// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import '../models/random_color_generator.dart';
import 'color_item.dart';
import 'color_type.dart';

class RandomListBasedColorGenerator implements RandomColorGenerator {
  final List<ColorItem> colors;

  RandomListBasedColorGenerator(this.colors);

  @override
  ColorType get colorType => throw UnimplementedError();

  @override
  bool contains(ColorItem color) {
    return colors.contains(color);
  }

  @override
  ColorItem elementAt(int index) {
    return colors[index];
  }

  @override
  int get length => colors.length;

  @override
  ColorItem next(Random random) {
    return colors[random.nextInt(colors.length)];
  }
}
