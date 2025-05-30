// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../../common/urls.dart' as urls;
import '../../utils/utils.dart' as utils;
import '../common/consts.dart' as consts;
import '../common/strings.dart' as strings;
import '../models/color_type.dart';
import '../models/more.dart';
import '../models/random_color_generator.dart';
import '../models/random_color_generators/random_attractive_color_generator.dart' as racg;
import '../models/random_color_generators/random_basic_color_generator.dart' as rbcg;
import '../models/random_color_generators/random_named_color_generator.dart' as rncg;
import '../models/random_color_generators/random_true_color_generator.dart' as rtcg;
import '../models/random_color_generators/random_web_color_generator.dart' as rwcg;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;
import '../widgets/color_list_view.dart';

/// A screen that displays all the available colors of a specific type in a list view.
class AvailableColorsScreen extends StatefulWidget {
  const AvailableColorsScreen({super.key, required this.colorType, this.initialRandomColor});

  /// The type of available colors to display.
  final ColorType colorType;

  /// The initial random color to select in the list view.
  final RandomColor? initialRandomColor;

  @override
  State<AvailableColorsScreen> createState() => _AvailableColorsScreenState();
}

class _AvailableColorsScreenState extends State<AvailableColorsScreen> {
  late final ScrollController _scrollController;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Scroll to the initial random color if provided
    final double itemOffset =
        widget.initialRandomColor != null
            ? (widget.initialRandomColor!.listPosition ?? 0) * consts.colorListItemExtent
            : 0.0;
    _scrollController = ScrollController(initialScrollOffset: itemOffset, keepScrollOffset: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Returns the number of items in the list view based on the selected color type.
  int _getItemCount() {
    return switch (widget.colorType) {
      ColorType.mixedColor =>
        throw UnsupportedError('The available colors list does not support mixed colors.'),
      ColorType.basicColor => rbcg.kBasicColors.length,
      ColorType.webColor => rwcg.kWebColors.length,
      ColorType.namedColor => rncg.kNamedColors.length,
      ColorType.attractiveColor => racg.possibilityCount,
      ColorType.trueColor => rtcg.possibilityCount,
    };
  }

  /// Returns the data that should be used to build the item at the given [index] in the list view.
  ColorListItemData _getItemData(int index) {
    // Returns the data for a named color list item.
    ColorListItemData namedColorListItemData(KnownColor item) => (
      color: Color(item.code),
      title: item.name,
      subtitle: color_utils.toHexString(Color(item.code)),
    );

    switch (widget.colorType) {
      case ColorType.mixedColor:
        throw UnsupportedError('The available colors list does not support mixed colors.');
      case ColorType.basicColor:
        return namedColorListItemData(rbcg.kBasicColors.elementAt(index));
      case ColorType.webColor:
        return namedColorListItemData(rwcg.kWebColors.elementAt(index));
      case ColorType.namedColor:
        return namedColorListItemData(rncg.kNamedColors.elementAt(index));
      case ColorType.attractiveColor:
        final int colorCode = racg.kAttractiveColors[index];
        return (
          color: Color(colorCode),
          title: color_utils.toHexString(Color(colorCode)),
          subtitle: null,
        );
      case ColorType.trueColor:
        final int colorCode = color_utils.withFullAlpha(index);
        return (
          color: Color(colorCode),
          title: color_utils.toHexString(Color(colorCode)),
          subtitle: null,
        );
    }
  }

  /// Pops the top-most route off the navigator and returns a random color object for the color at
  /// the given [index].
  void _popRandomColor(BuildContext context, int index) {
    Navigator.of(context).pop<RandomColor>(getRandomColor(widget.colorType, index));
  }

  /// Opens the "About These Colors" help page in the default web browser.
  void _openAboutTheseColors() {
    utils.launchUrlExternal(context, urls.aboutTheseColors(widget.colorType.toShortString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A simple app bar with the title based on the color type
      appBar: AppBar(
        title: Text(strings.availableColors(widget.colorType)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: strings.aboutTheseColorsTooltip,
            onPressed: _openAboutTheseColors,
          ),
        ],
      ),

      body: ColorListView(
        scrollController: _scrollController,
        itemCount: _getItemCount,
        itemData: _getItemData,
        onItemTap: (int index) => _popRandomColor(context, index),
      ),
    );
  }
}
