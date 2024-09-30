// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:ui';

import 'color_type.dart';
import 'random_color.dart';

/// A color with a code and a name.
typedef ColorWithName = ({int code, String name});

// typedef ColorWithNameEx = ({int code, String name, int position});

class ColorWithNameEx {
  final int code;

  final String name;

  final int position;

  ColorWithNameEx({required this.code, required this.name, required this.position});

  RandomColor toRandomColor(ColorType colorType) {
    print('******** ColorHap: Mapping color $name with code $code to type $colorType');
    return RandomColor(
      type: colorType,
      color: Color(code),
      name: name,
      listPosition: position,
    );
  }
}
