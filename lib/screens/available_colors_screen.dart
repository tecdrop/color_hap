// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../../common/urls.dart' as urls;
import '../../utils/utils.dart' as utils;
import '../common/consts.dart' as consts;
import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../models/color_type.dart';
import '../models/random_color_generator.dart';
import '../widgets/color_list_view.dart';

/// A screen that displays all the available colors of a specific type in a list view.
class AvailableColorsScreen extends StatefulWidget {
  const AvailableColorsScreen({super.key, required this.generator, this.initialColor});

  /// The color generator whose colors should be displayed.
  final RandomColorGenerator generator;

  /// The initial random color to select in the list view.
  final ColorItem? initialColor;

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
    final itemOffset = widget.initialColor != null
        ? (widget.initialColor!.listPosition ?? 0) * consts.colorListItemExtent
        : 0.0;
    _scrollController = ScrollController(initialScrollOffset: itemOffset, keepScrollOffset: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Pops the top-most route off the navigator and returns a random color object for the color at
  /// the given [index].
  void _popRandomColor(BuildContext context, int index) {
    Navigator.of(context).pop<ColorItem>(widget.generator.elementAt(index));
  }

  /// Opens the "About These Colors" help page in the default web browser.
  void _openAboutTheseColors() {
    utils.launchUrlExternal(
      context,
      urls.aboutTheseColors(widget.generator.colorType.id),
    );
  }

  /// Determines whether to show the color type for a given color item.
  ///
  /// For the True Colors screen, only show the color type for known colors
  /// (basic/web/named/attractive) that appear among the true colors.
  /// For all other screens, always show the color type.
  bool _shouldShowColorType(ColorItem item) {
    return widget.generator.colorType == ColorType.trueColor && item.type != ColorType.trueColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A simple app bar with the title based on the color type
      appBar: AppBar(
        title: Text(strings.availableColors(widget.generator.colorType)),
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
        itemCount: widget.generator.length,
        itemData: widget.generator.elementAt,
        showColorType: _shouldShowColorType,
        onItemTap: (int index) => _popRandomColor(context, index),
      ),
    );
  }
}
