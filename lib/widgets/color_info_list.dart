// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;

/// A list view of color information items.
class ColorInfoList extends StatelessWidget {
  /// Creates a new [ColorInfoList] instance.
  const ColorInfoList({
    super.key,
    required this.randomColor,
    required this.infos,
    this.onCopyPressed,
  });

  /// The random color whose information is displayed in the list.
  final RandomColor randomColor;

  /// The list of color information items to display.
  final List<({String key, String value})> infos;

  /// A callback function that is called when the copy button of an info item is pressed.
  final Function(String key, String value)? onCopyPressed;

  @override
  Widget build(BuildContext context) {
    final Color color = randomColor.color;
    final Color contrastColor = color_utils.contrastColor(color);
    final double width = MediaQuery.of(context).size.width;

    return DividerTheme(
      data: DividerThemeData(
        color: contrastColor,
        // thickness: 0.5,
        thickness: 0.0,
        space: 0.0,
      ),
      child: ListTileTheme(
        // textColor: contrastColor,
        // iconColor: contrastColor,
        // selectedTileColor: contrastColor.withAlpha(50),
        // selectedColor: contrastColor,

        // child: ListView.builder(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: max(0, (width - 800) / 2),
            vertical: 16.0,
          ),
          itemCount: infos.length,
          itemBuilder: (BuildContext context, int index) {
            final info = infos[index];
            return _ColorInfoItem(
              // color: color,
              textColor: contrastColor,
              infoKey: info.key,
              infoValue: info.value,
              onCopyPressed: () => onCopyPressed?.call(info.key, info.value),
              onSharePressed: () => onCopyPressed?.call(info.key, info.value),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}

class _ColorInfoItem extends StatelessWidget {
  const _ColorInfoItem({
    super.key, // ignore: unused_element
    required this.textColor,
    required this.infoKey,
    required this.infoValue,
    this.onCopyPressed,
    this.onSharePressed,
  });

  final Color textColor;

  final String infoKey;

  final String infoValue;

  final Function()? onCopyPressed;

  final Function()? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      textColor: textColor,
      iconColor: textColor.withOpacity(0.7),
      // selectedTileColor: contrastColor.withAlpha(50),
      // selectedColor: contrastColor,
      title: Text(infoValue, style: const TextStyle(fontSize: 20.0)),
      subtitle: Text(infoKey),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Add a Copy button to the list item
          IconButton(
            icon: const Icon(Icons.content_copy_outlined),
            onPressed: onCopyPressed,
          ),
          // Add a Share button to the list item
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: onSharePressed,
          ),
        ],
      ),
    );
  }
}
