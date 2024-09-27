// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

/// Application-wide constants.
library;

/// The parameter name for colors with no name.
const String noNameColorParam = 'noname';

/// The color swatch image file name for a given hex code.
String colorSwatchFileName(String hexCode) => 'colorhap_${hexCode}_random_color_swatch.png';
