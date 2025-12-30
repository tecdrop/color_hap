// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Branding colors used for generating marketing screenshots.
///
/// These are dev-only colors that can be loaded via the Favorites screen menu to facilitate
/// consistent screenshot generation across different screens of the app.
library;

import 'package:flutter/material.dart';

import '../models/color_item.dart';
import '../models/color_type.dart';

/// The predefined list of branding colors for screenshot generation.
const List<ColorItem> screenshotColors = [
  ColorItem(
    type: ColorType.basicColor,
    color: Color(0XFF0088FF),
    name: 'azure',
    listPosition: 0,
  ),
  ColorItem(
    type: ColorType.trueColor,
    color: Color(0xFF8700FE),
    listPosition: 0,
  ),
  ColorItem(
    type: ColorType.namedColor,
    color: Color(0xFFFFEC13),
    name: 'Broom',
    listPosition: 0,
  ),
  ColorItem(
    type: ColorType.trueColor,
    color: Color(0xFF00FF22),
    listPosition: 0,
  ),
  ColorItem(
    type: ColorType.basicColor,
    color: Color(0XFFFF0000),
    name: 'red',
    listPosition: 0,
  ),
  ColorItem(
    type: ColorType.basicColor,
    color: Color(0XFFFF00FF),
    name: 'magenta',
    listPosition: 0,
  ),
  ColorItem(
    type: ColorType.basicColor,
    color: Color(0XFF8800FF),
    name: 'violet',
    listPosition: 0,
  ),
];
