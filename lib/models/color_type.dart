// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// An enhanced enum to specify the different kinds of random colors.
enum ColorType {
  mixedColor(id: 'mixed', name: 'Mixed Color'),
  basicColor(id: 'basic', name: 'Basic Color'),
  webColor(id: 'web', name: 'Web Color'),
  namedColor(id: 'named', name: 'Named Color'),
  attractiveColor(id: 'attractive', name: 'Attractive Color'),
  trueColor(id: 'true', name: 'True Color');

  const ColorType({required this.id, required this.name});

  final String id;

  final String name;
}
