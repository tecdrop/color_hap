// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:collection/collection.dart';

/// An enhanced enum to specify the different kinds of random colors.
enum ColorType {
  mixedColor(id: 'mixed', name: 'Mixed Color', prefix: 'M'),
  basicColor(id: 'basic', name: 'Basic Color', prefix: 'B'),
  webColor(id: 'web', name: 'Web Color', prefix: 'W'),
  namedColor(id: 'named', name: 'Named Color', prefix: 'N'),
  attractiveColor(id: 'attractive', name: 'Attractive Color', prefix: 'A'),
  trueColor(id: 'true', name: 'True Color', prefix: 'T')
  ;

  /// Creates a new instance of [ColorType].
  const ColorType({
    required this.id,
    required this.name,
    required this.prefix,
  });

  /// The unique identifier of the color type.
  final String id;

  /// The name of the color type.
  final String name;

  /// The single-character prefix used for compact storage keys.
  final String prefix;

  /// Returns the [ColorType] corresponding to the given [prefix], or null if not found.
  static ColorType? fromPrefix(String prefix) {
    return ColorType.values.firstWhereOrNull((type) => type.prefix == prefix);
  }
}
