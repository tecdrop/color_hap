// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import '../models/random_color_generator.dart';
import 'color_item.dart';
import 'color_type.dart';

/// An abstract class that represents a random color generator based on a list of colors.
abstract class RandomListBasedColorGenerator implements RandomColorGenerator {
  RandomListBasedColorGenerator(this.colors);

  /// The list of colors to choose from.
  final List<ColorItem> colors;

  /// The type of colors generated should be defined in subclasses.
  @override
  ColorType get colorType => throw UnimplementedError();

  /// Returns a random color from the predefined list.
  @override
  ColorItem next(Random random) {
    return colors[random.nextInt(colors.length)];
  }

  /// The number of colors in the predefined list.
  @override
  int get length => colors.length;

  /// Returns the color at the given index from the predefined list.
  @override
  ColorItem elementAt(int index) {
    return colors[index];
  }
}
