// Copyright 2020-2022 Tecdrop. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// This file implements a generator of random web colors (CSS named colors).

import 'dart:math';
import 'package:flutter/material.dart';

import 'random_color.dart';

/// Generates a random web color (CSS named color).
///
/// The returned [RandomColor] has both a [Color] value and a name.
RandomColor nextRandomColor(Random random) {
  final int randomIndex = random.nextInt(_webColors.length);
  final namedColor = _webColors.entries.elementAt(randomIndex);

  return RandomColor(
    color: Color(namedColor.key),
    name: namedColor.value,
    type: ColorType.webColor,
  );
}

/// Returns the name of the given [Color], if the color is a valid web color.
String? getColorName(Color color) => _webColors[color.value];

/// The number of available web colors that can be used to generate the random color.
int get possibilityCount => _webColors.length;

// cSpell: disable

/// A map of integer [Color] value constants corresponding to the CSS named colors.
///
/// Scraped from [CSS Color Module Level 4](https://www.w3.org/TR/css-color-4/) using
/// ```js
/// copy($$('.named-color-table tbody tr').map(tr => tr.querySelector('td:nth-child(4)').innerText.replace('#', '0xFF') + ': \'' + tr.querySelector('dfn').innerText + '\',').join('\r\n'))
/// ```
const Map<int, String> _webColors = {
  0xFFF0F8FF: 'aliceblue',
  0xFFFAEBD7: 'antiquewhite',
  0xFF00FFFF: 'aqua',
  0xFF7FFFD4: 'aquamarine',
  0xFFF0FFFF: 'azure',
  0xFFF5F5DC: 'beige',
  0xFFFFE4C4: 'bisque',
  0xFF000000: 'black',
  0xFFFFEBCD: 'blanchedalmond',
  0xFF0000FF: 'blue',
  0xFF8A2BE2: 'blueviolet',
  0xFFA52A2A: 'brown',
  0xFFDEB887: 'burlywood',
  0xFF5F9EA0: 'cadetblue',
  0xFF7FFF00: 'chartreuse',
  0xFFD2691E: 'chocolate',
  0xFFFF7F50: 'coral',
  0xFF6495ED: 'cornflowerblue',
  0xFFFFF8DC: 'cornsilk',
  0xFFDC143C: 'crimson',
  // 0xFF00FFFF: 'cyan', // duplicate of aqua
  0xFF00008B: 'darkblue',
  0xFF008B8B: 'darkcyan',
  0xFFB8860B: 'darkgoldenrod',
  // 0xFFA9A9A9: 'darkgray', // duplicate of darkgrey
  0xFF006400: 'darkgreen',
  0xFFA9A9A9: 'darkgrey',
  0xFFBDB76B: 'darkkhaki',
  0xFF8B008B: 'darkmagenta',
  0xFF556B2F: 'darkolivegreen',
  0xFFFF8C00: 'darkorange',
  0xFF9932CC: 'darkorchid',
  0xFF8B0000: 'darkred',
  0xFFE9967A: 'darksalmon',
  0xFF8FBC8F: 'darkseagreen',
  0xFF483D8B: 'darkslateblue',
  // 0xFF2F4F4F: 'darkslategray', // duplicate of darkslategrey
  0xFF2F4F4F: 'darkslategrey',
  0xFF00CED1: 'darkturquoise',
  0xFF9400D3: 'darkviolet',
  0xFFFF1493: 'deeppink',
  0xFF00BFFF: 'deepskyblue',
  // 0xFF696969: 'dimgray', // duplicate of dimgrey
  0xFF696969: 'dimgrey',
  0xFF1E90FF: 'dodgerblue',
  0xFFB22222: 'firebrick',
  0xFFFFFAF0: 'floralwhite',
  0xFF228B22: 'forestgreen',
  // 0xFFFF00FF: 'fuchsia', // duplicate of magenta
  0xFFDCDCDC: 'gainsboro',
  0xFFF8F8FF: 'ghostwhite',
  0xFFFFD700: 'gold',
  0xFFDAA520: 'goldenrod',
  // 0xFF808080: 'gray', // duplicate of grey
  0xFF008000: 'green',
  0xFFADFF2F: 'greenyellow',
  0xFF808080: 'grey',
  0xFFF0FFF0: 'honeydew',
  0xFFFF69B4: 'hotpink',
  0xFFCD5C5C: 'indianred',
  0xFF4B0082: 'indigo',
  0xFFFFFFF0: 'ivory',
  0xFFF0E68C: 'khaki',
  0xFFE6E6FA: 'lavender',
  0xFFFFF0F5: 'lavenderblush',
  0xFF7CFC00: 'lawngreen',
  0xFFFFFACD: 'lemonchiffon',
  0xFFADD8E6: 'lightblue',
  0xFFF08080: 'lightcoral',
  0xFFE0FFFF: 'lightcyan',
  0xFFFAFAD2: 'lightgoldenrodyellow',
  // 0xFFD3D3D3: 'lightgray', // duplicate of lightgrey
  0xFF90EE90: 'lightgreen',
  0xFFD3D3D3: 'lightgrey',
  0xFFFFB6C1: 'lightpink',
  0xFFFFA07A: 'lightsalmon',
  0xFF20B2AA: 'lightseagreen',
  0xFF87CEFA: 'lightskyblue',
  // 0xFF778899: 'lightslategray', // duplicate of lightslategrey
  0xFF778899: 'lightslategrey',
  0xFFB0C4DE: 'lightsteelblue',
  0xFFFFFFE0: 'lightyellow',
  0xFF00FF00: 'lime',
  0xFF32CD32: 'limegreen',
  0xFFFAF0E6: 'linen',
  0xFFFF00FF: 'magenta',
  0xFF800000: 'maroon',
  0xFF66CDAA: 'mediumaquamarine',
  0xFF0000CD: 'mediumblue',
  0xFFBA55D3: 'mediumorchid',
  0xFF9370DB: 'mediumpurple',
  0xFF3CB371: 'mediumseagreen',
  0xFF7B68EE: 'mediumslateblue',
  0xFF00FA9A: 'mediumspringgreen',
  0xFF48D1CC: 'mediumturquoise',
  0xFFC71585: 'mediumvioletred',
  0xFF191970: 'midnightblue',
  0xFFF5FFFA: 'mintcream',
  0xFFFFE4E1: 'mistyrose',
  0xFFFFE4B5: 'moccasin',
  0xFFFFDEAD: 'navajowhite',
  0xFF000080: 'navy',
  0xFFFDF5E6: 'oldlace',
  0xFF808000: 'olive',
  0xFF6B8E23: 'olivedrab',
  0xFFFFA500: 'orange',
  0xFFFF4500: 'orangered',
  0xFFDA70D6: 'orchid',
  0xFFEEE8AA: 'palegoldenrod',
  0xFF98FB98: 'palegreen',
  0xFFAFEEEE: 'paleturquoise',
  0xFFDB7093: 'palevioletred',
  0xFFFFEFD5: 'papayawhip',
  0xFFFFDAB9: 'peachpuff',
  0xFFCD853F: 'peru',
  0xFFFFC0CB: 'pink',
  0xFFDDA0DD: 'plum',
  0xFFB0E0E6: 'powderblue',
  0xFF800080: 'purple',
  0xFF663399: 'rebeccapurple',
  0xFFFF0000: 'red',
  0xFFBC8F8F: 'rosybrown',
  0xFF4169E1: 'royalblue',
  0xFF8B4513: 'saddlebrown',
  0xFFFA8072: 'salmon',
  0xFFF4A460: 'sandybrown',
  0xFF2E8B57: 'seagreen',
  0xFFFFF5EE: 'seashell',
  0xFFA0522D: 'sienna',
  0xFFC0C0C0: 'silver',
  0xFF87CEEB: 'skyblue',
  0xFF6A5ACD: 'slateblue',
  // 0xFF708090: 'slategray', // duplicate of slategrey
  0xFF708090: 'slategrey',
  0xFFFFFAFA: 'snow',
  0xFF00FF7F: 'springgreen',
  0xFF4682B4: 'steelblue',
  0xFFD2B48C: 'tan',
  0xFF008080: 'teal',
  0xFFD8BFD8: 'thistle',
  0xFFFF6347: 'tomato',
  0xFF40E0D0: 'turquoise',
  0xFFEE82EE: 'violet',
  0xFFF5DEB3: 'wheat',
  0xFFFFFFFF: 'white',
  0xFFF5F5F5: 'whitesmoke',
  0xFFFFFF00: 'yellow',
  0xFF9ACD32: 'yellowgreen',
};
