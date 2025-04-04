// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

/// Implements a generator of random web colors (CSS named colors).
library;

import 'dart:math';
import 'package:flutter/material.dart';

import '../color_type.dart';
import '../more.dart';
import '../random_color.dart';

/// Generates a random web color (CSS named color).
///
/// The returned [RandomColor] has both a [Color] value and a name.
RandomColor nextRandomColor(Random random) {
  final int randomIndex = random.nextInt(kWebColors.length);
  final KnownColor webColor = kWebColors.elementAt(randomIndex);

  return RandomColor(
    type: ColorType.webColor,
    color: Color(webColor.code),
    name: webColor.name,
    listPosition: randomIndex,
  );
}

/// The number of available web colors that can be used to generate the random color.
int get possibilityCount => kWebColors.length;

/// A list of the web colors with their RGB values and names.
///
/// Scraped from [CSS Color Module Level 4](https://www.w3.org/TR/css-color-4/) using
/// ```js
/// copy($$('.named-color-table tbody tr').map(tr => tr.querySelector('td:nth-child(4)').innerText.replace('#', '0xFF') + ': \'' + tr.querySelector('dfn').innerText + '\',').join('\r\n'))
/// ```
const List<KnownColor> kWebColors = [
  (code: 0XFFF0F8FF, name: 'aliceblue'),
  (code: 0XFFFAEBD7, name: 'antiquewhite'),
  (code: 0XFF00FFFF, name: 'aqua'),
  (code: 0XFF7FFFD4, name: 'aquamarine'),
  (code: 0XFFF0FFFF, name: 'azure'),
  (code: 0XFFF5F5DC, name: 'beige'),
  (code: 0XFFFFE4C4, name: 'bisque'),
  (code: 0XFF000000, name: 'black'),
  (code: 0XFFFFEBCD, name: 'blanchedalmond'),
  (code: 0XFF0000FF, name: 'blue'),
  (code: 0XFF8A2BE2, name: 'blueviolet'),
  (code: 0XFFA52A2A, name: 'brown'),
  (code: 0XFFDEB887, name: 'burlywood'),
  (code: 0XFF5F9EA0, name: 'cadetblue'),
  (code: 0XFF7FFF00, name: 'chartreuse'),
  (code: 0XFFD2691E, name: 'chocolate'),
  (code: 0XFFFF7F50, name: 'coral'),
  (code: 0XFF6495ED, name: 'cornflowerblue'),
  (code: 0XFFFFF8DC, name: 'cornsilk'),
  (code: 0XFFDC143C, name: 'crimson'),
  (code: 0xFF00FFFF, name: 'cyan'), // duplicate of aqua
  (code: 0XFF00008B, name: 'darkblue'),
  (code: 0XFF008B8B, name: 'darkcyan'),
  (code: 0XFFB8860B, name: 'darkgoldenrod'),
  (code: 0xFFA9A9A9, name: 'darkgray'), // duplicate of darkgrey
  (code: 0XFF006400, name: 'darkgreen'),
  (code: 0XFFA9A9A9, name: 'darkgrey'),
  (code: 0XFFBDB76B, name: 'darkkhaki'),
  (code: 0XFF8B008B, name: 'darkmagenta'),
  (code: 0XFF556B2F, name: 'darkolivegreen'),
  (code: 0XFFFF8C00, name: 'darkorange'),
  (code: 0XFF9932CC, name: 'darkorchid'),
  (code: 0XFF8B0000, name: 'darkred'),
  (code: 0XFFE9967A, name: 'darksalmon'),
  (code: 0XFF8FBC8F, name: 'darkseagreen'),
  (code: 0XFF483D8B, name: 'darkslateblue'),
  (code: 0xFF2F4F4F, name: 'darkslategray'), // duplicate of darkslategrey
  (code: 0XFF2F4F4F, name: 'darkslategrey'),
  (code: 0XFF00CED1, name: 'darkturquoise'),
  (code: 0XFF9400D3, name: 'darkviolet'),
  (code: 0XFFFF1493, name: 'deeppink'),
  (code: 0XFF00BFFF, name: 'deepskyblue'),
  (code: 0xFF696969, name: 'dimgray'), // duplicate of dimgrey
  (code: 0XFF696969, name: 'dimgrey'),
  (code: 0XFF1E90FF, name: 'dodgerblue'),
  (code: 0XFFB22222, name: 'firebrick'),
  (code: 0XFFFFFAF0, name: 'floralwhite'),
  (code: 0XFF228B22, name: 'forestgreen'),
  (code: 0xFFFF00FF, name: 'fuchsia'), // duplicate of magenta
  (code: 0XFFDCDCDC, name: 'gainsboro'),
  (code: 0XFFF8F8FF, name: 'ghostwhite'),
  (code: 0XFFFFD700, name: 'gold'),
  (code: 0XFFDAA520, name: 'goldenrod'),
  (code: 0xFF808080, name: 'gray'), // duplicate of grey
  (code: 0XFF008000, name: 'green'),
  (code: 0XFFADFF2F, name: 'greenyellow'),
  (code: 0XFF808080, name: 'grey'),
  (code: 0XFFF0FFF0, name: 'honeydew'),
  (code: 0XFFFF69B4, name: 'hotpink'),
  (code: 0XFFCD5C5C, name: 'indianred'),
  (code: 0XFF4B0082, name: 'indigo'),
  (code: 0XFFFFFFF0, name: 'ivory'),
  (code: 0XFFF0E68C, name: 'khaki'),
  (code: 0XFFE6E6FA, name: 'lavender'),
  (code: 0XFFFFF0F5, name: 'lavenderblush'),
  (code: 0XFF7CFC00, name: 'lawngreen'),
  (code: 0XFFFFFACD, name: 'lemonchiffon'),
  (code: 0XFFADD8E6, name: 'lightblue'),
  (code: 0XFFF08080, name: 'lightcoral'),
  (code: 0XFFE0FFFF, name: 'lightcyan'),
  (code: 0XFFFAFAD2, name: 'lightgoldenrodyellow'),
  (code: 0xFFD3D3D3, name: 'lightgray'), // duplicate of lightgrey
  (code: 0XFF90EE90, name: 'lightgreen'),
  (code: 0XFFD3D3D3, name: 'lightgrey'),
  (code: 0XFFFFB6C1, name: 'lightpink'),
  (code: 0XFFFFA07A, name: 'lightsalmon'),
  (code: 0XFF20B2AA, name: 'lightseagreen'),
  (code: 0XFF87CEFA, name: 'lightskyblue'),
  (code: 0xFF778899, name: 'lightslategray'), // duplicate of lightslategrey
  (code: 0XFF778899, name: 'lightslategrey'),
  (code: 0XFFB0C4DE, name: 'lightsteelblue'),
  (code: 0XFFFFFFE0, name: 'lightyellow'),
  (code: 0XFF00FF00, name: 'lime'),
  (code: 0XFF32CD32, name: 'limegreen'),
  (code: 0XFFFAF0E6, name: 'linen'),
  (code: 0XFFFF00FF, name: 'magenta'),
  (code: 0XFF800000, name: 'maroon'),
  (code: 0XFF66CDAA, name: 'mediumaquamarine'),
  (code: 0XFF0000CD, name: 'mediumblue'),
  (code: 0XFFBA55D3, name: 'mediumorchid'),
  (code: 0XFF9370DB, name: 'mediumpurple'),
  (code: 0XFF3CB371, name: 'mediumseagreen'),
  (code: 0XFF7B68EE, name: 'mediumslateblue'),
  (code: 0XFF00FA9A, name: 'mediumspringgreen'),
  (code: 0XFF48D1CC, name: 'mediumturquoise'),
  (code: 0XFFC71585, name: 'mediumvioletred'),
  (code: 0XFF191970, name: 'midnightblue'),
  (code: 0XFFF5FFFA, name: 'mintcream'),
  (code: 0XFFFFE4E1, name: 'mistyrose'),
  (code: 0XFFFFE4B5, name: 'moccasin'),
  (code: 0XFFFFDEAD, name: 'navajowhite'),
  (code: 0XFF000080, name: 'navy'),
  (code: 0XFFFDF5E6, name: 'oldlace'),
  (code: 0XFF808000, name: 'olive'),
  (code: 0XFF6B8E23, name: 'olivedrab'),
  (code: 0XFFFFA500, name: 'orange'),
  (code: 0XFFFF4500, name: 'orangered'),
  (code: 0XFFDA70D6, name: 'orchid'),
  (code: 0XFFEEE8AA, name: 'palegoldenrod'),
  (code: 0XFF98FB98, name: 'palegreen'),
  (code: 0XFFAFEEEE, name: 'paleturquoise'),
  (code: 0XFFDB7093, name: 'palevioletred'),
  (code: 0XFFFFEFD5, name: 'papayawhip'),
  (code: 0XFFFFDAB9, name: 'peachpuff'),
  (code: 0XFFCD853F, name: 'peru'),
  (code: 0XFFFFC0CB, name: 'pink'),
  (code: 0XFFDDA0DD, name: 'plum'),
  (code: 0XFFB0E0E6, name: 'powderblue'),
  (code: 0XFF800080, name: 'purple'),
  (code: 0XFF663399, name: 'rebeccapurple'),
  (code: 0XFFFF0000, name: 'red'),
  (code: 0XFFBC8F8F, name: 'rosybrown'),
  (code: 0XFF4169E1, name: 'royalblue'),
  (code: 0XFF8B4513, name: 'saddlebrown'),
  (code: 0XFFFA8072, name: 'salmon'),
  (code: 0XFFF4A460, name: 'sandybrown'),
  (code: 0XFF2E8B57, name: 'seagreen'),
  (code: 0XFFFFF5EE, name: 'seashell'),
  (code: 0XFFA0522D, name: 'sienna'),
  (code: 0XFFC0C0C0, name: 'silver'),
  (code: 0XFF87CEEB, name: 'skyblue'),
  (code: 0XFF6A5ACD, name: 'slateblue'),
  (code: 0xFF708090, name: 'slategray'), // duplicate of slategrey
  (code: 0XFF708090, name: 'slategrey'),
  (code: 0XFFFFFAFA, name: 'snow'),
  (code: 0XFF00FF7F, name: 'springgreen'),
  (code: 0XFF4682B4, name: 'steelblue'),
  (code: 0XFFD2B48C, name: 'tan'),
  (code: 0XFF008080, name: 'teal'),
  (code: 0XFFD8BFD8, name: 'thistle'),
  (code: 0XFFFF6347, name: 'tomato'),
  (code: 0XFF40E0D0, name: 'turquoise'),
  (code: 0XFFEE82EE, name: 'violet'),
  (code: 0XFFF5DEB3, name: 'wheat'),
  (code: 0XFFFFFFFF, name: 'white'),
  (code: 0XFFF5F5F5, name: 'whitesmoke'),
  (code: 0XFFFFFF00, name: 'yellow'),
  (code: 0XFF9ACD32, name: 'yellowgreen'),
];
