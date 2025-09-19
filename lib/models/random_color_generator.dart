// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import 'color_item.dart';
import 'color_type.dart';

abstract interface class RandomColorGenerator {
  ColorType get colorType;

  ColorItem next(Random random);

  int get length;

  ColorItem elementAt(int index);

  bool contains(ColorItem color);
}
