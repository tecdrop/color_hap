// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Application-wide constants.
library;

/// The parameter name for colors with no name.
const noNameColorParam = 'noname';

/// The color swatch image file name for a given hex code.
String colorSwatchFileName(String hexCode) => 'colorhap_${hexCode}_random_color_swatch.png';

/// The name of the favorites CSV export file.
const favoritesCSVFileName = 'colorhap_favorites.csv';

/// The height of the color list item.
const colorListItemExtent = 128.0;

/// The maximum content width for constraining list view items on large screens.
const maxContentWidth = 800.0;
