// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// An enhanced enum to specify the different kinds of random colors.
enum ColorType {
  mixedColor(id: 'mixed', name: 'Mixed Color'),
  basicColor(id: 'basic', name: 'Basic Color'),
  webColor(id: 'web', name: 'Web Color'),
  namedColor(id: 'named', name: 'Named Color'),
  attractiveColor(id: 'attractive', name: 'Attractive Color'),
  trueColor(id: 'true', name: 'True Color')
  ;

  /// Creates a new instance of [ColorType].
  const ColorType({
    required this.id,
    required this.name,
  });

  /// The unique identifier of the color type.
  final String id;

  /// The name of the color type.
  final String name;
}
