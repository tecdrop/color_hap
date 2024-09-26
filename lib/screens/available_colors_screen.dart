// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/color_type.dart';
import '../models/random_color_generators/random_attractive_color_generator.dart' as racg;
import '../models/random_color_generators/random_basic_color_generator.dart' as rbcg;
import '../models/random_color_generators/random_named_color_generator.dart' as rncg;
import '../models/random_color_generators/random_true_color_generator.dart' as rtcg;
import '../models/random_color_generators/random_web_color_generator.dart' as rwcg;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;
import '../widgets/available_colors_list_view.dart';

/// The storage bucket used to store the scroll position of the available colors list views.
final PageStorageBucket _storageBucket = PageStorageBucket();

/// A screen that displays all the available colors of a specific type in a list view.
class AvailableColorsScreen extends StatelessWidget {
  const AvailableColorsScreen({
    super.key,
    required this.colorType,
  });

  /// The type of available colors to display.
  final ColorType colorType;

  /// Returns the number of items in the list view based on the selected color type.
  int _getItemCount() {
    return switch (colorType) {
      ColorType.mixedColor => 0, // TODO: Implement mixed colors?
      ColorType.basicColor => rbcg.kBasicColors.length,
      ColorType.webColor => rwcg.kWebColors.length,
      ColorType.namedColor => rncg.kNamedColors.length,
      ColorType.attractiveColor => racg.possibilityCount,
      ColorType.trueColor => rtcg.possibilityCount,
    };
  }

  /// Returns the data that should be used to build the item at the given [index] in the list view.
  ({int colorCode, String? title}) _getItemData(int index) {
    switch (colorType) {
      case ColorType.mixedColor:
        return (colorCode: 0, title: null); // TODO: Implement mixed colors?
      case ColorType.basicColor:
        final MapEntry<int, String> entry = rbcg.kBasicColors.entries.elementAt(index);
        return (colorCode: entry.key, title: entry.value);
      case ColorType.webColor:
        final MapEntry<int, String> entry = rwcg.kWebColors.entries.elementAt(index);
        return (colorCode: entry.key, title: entry.value);
      case ColorType.namedColor:
        final MapEntry<int, String> entry = rncg.kNamedColors.entries.elementAt(index);
        return (colorCode: entry.key, title: entry.value);
      case ColorType.attractiveColor:
        return (colorCode: 0, title: null); // TODO: Implement attractive colors?
      case ColorType.trueColor:
        final int colorCode = color_utils.withFullAlpha(index);
        return (colorCode: colorCode, title: null);
    }
  }

  /// Pops the top-most route off the navigator and returns a random color object for the color at
  /// the given [index].
  void _popRandomColor(BuildContext context, int index) {
    final itemData = _getItemData(index);
    final RandomColor randomColor = RandomColor(
      color: Color(itemData.colorCode),
      type: colorType,
      name: itemData.title,
    );
    Navigator.of(context).pop<RandomColor>(randomColor);
  }

  @override
  Widget build(BuildContext context) {
    // Use PageStorage to store the scroll position of the list views while the app is running
    return PageStorage(
      bucket: _storageBucket,
      child: Scaffold(
        // A simple app bar with the title based on the color type
        appBar: AppBar(
          title: Text(strings.availableColors(colorType)),
        ),

        // The list view of available colors of the selected type
        body: AvailableColorsListView(
          key: PageStorageKey<ColorType>(colorType),
          itemCount: _getItemCount,
          itemData: _getItemData,
          onItemTap: (int index) => _popRandomColor(context, index),
        ),
      ),
    );
  }
}
