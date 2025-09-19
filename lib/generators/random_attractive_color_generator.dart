// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import '../models/color_type.dart';
import '../models/random_list_based_color_generator.dart';

class RandomAttractiveColorGenerator extends RandomListBasedColorGenerator {
  RandomAttractiveColorGenerator(super.colors);

  @override
  ColorType get colorType => ColorType.attractiveColor;
}
