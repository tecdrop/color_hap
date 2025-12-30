// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../utils/color_utils.dart' as color_utils;
import '../widgets/color_list_view.dart';

/// A screen that displays shades of a given color in a list view.
///
/// Allows the user to select a shade, which will be returned to the previous screen.
class ColorShadesScreen extends StatefulWidget {
  const ColorShadesScreen({
    super.key,
    required this.color,
  });

  /// The base color for which shades are to be displayed.
  final Color color;

  @override
  State<ColorShadesScreen> createState() => _ColorShadesScreenState();
}

class _ColorShadesScreenState extends State<ColorShadesScreen> {
  /// The list of shade color items generated from the base color.
  late final List<ColorItem> _shadeColorItems;

  @override
  void initState() {
    super.initState();

    /// Generate shades of the provided color and create ColorItem instances for each shade
    final shades = color_utils.generateShades(widget.color, count: 15);
    _shadeColorItems = shades
        .map(
          (color) => ColorItem(
            type: .trueColor,
            color: color,
            listPosition: color_utils.toRGB24(color),
          ),
        )
        .toList();
  }

  /// Returns to the previous screen with the selected shade color at the given [index].
  void _popShadeColor(int index) {
    Navigator.of(context).pop<ColorItem>(_shadeColorItems[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A simple app bar with just the screen title
      appBar: AppBar(
        title: const Text(strings.colorShadesScreenTitle),
      ),

      body: ColorListView(
        itemCount: _shadeColorItems.length,
        itemData: (int index) => _shadeColorItems[index],
        showColorType: false,
        onItemTap: (int index) => _popShadeColor(index),
      ),
    );
  }
}
