// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;

/// A list view of color information items.
class ColorInfoList extends StatefulWidget {
  /// Creates a new [ColorInfoList] instance.
  const ColorInfoList({
    super.key,
    required this.randomColor,
    required this.infos,
    this.onCopyPressed,
  });

  /// The random color whose information is displayed in the list.
  final RandomColor randomColor;

  final List<({String key, String value})> infos;

  /// A callback function that is called when the copy button of an info item is pressed.
  final Function(String key, String value)? onCopyPressed;

  @override
  State<ColorInfoList> createState() => _ColorInfoListState();
}

class _ColorInfoListState extends State<ColorInfoList> {
  int _selectedInfoIndex = 0;

  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.infos.length, (_) => FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.randomColor.color;
    final Color contrastColor = color_utils.contrastColor(color);
    final double width = MediaQuery.of(context).size.width;

    return ListTileTheme(
      textColor: contrastColor,
      iconColor: contrastColor,
      selectedTileColor: contrastColor.withAlpha(50),
      selectedColor: contrastColor,

      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: max(0, (width - 800) / 2),
          vertical: 16.0,
        ),
        itemCount: widget.infos.length,
        itemBuilder: (BuildContext context, int index) {
          final info = widget.infos[index];
          return _ColorInfoItem(
            color: color,
            infoKey: info.key,
            infoValue: info.value,
            isSelected: _selectedInfoIndex == index,
            focusNode: _focusNodes[index],
            onSelected: () {
              setState(() {
                _selectedInfoIndex = index;
              });
            },
            onCopyPressed: () => widget.onCopyPressed?.call(info.key, info.value),
            onSharePressed: () => widget.onCopyPressed?.call(info.key, info.value),
            onFocused: () => setState(() {}),
          );
        },
      ),
      // iconColor: color_utils.contrastIconColor(randomColor.color),
      // child: ListView(
      //   // Use padding to constrain the width of the list view so it looks ok on large screens
      //   padding: EdgeInsets.symmetric(
      //     horizontal: max(0, (width - 800) / 2),
      //     vertical: 16.0,
      //   ),

      //   children: <Widget>[
      //     // Add the color information list items
      //     if (widget.randomColor.name != null) ...[
      //       _buildInfoItem(0, strings.colorTitleInfo, widget.randomColor.title),
      //       _buildInfoItem(1, strings.colorNameInfo, widget.randomColor.name!),
      //     ],
      //     _buildInfoItem(2, strings.hexInfo, color_utils.toHexString(color)),
      //     _buildInfoItem(3, strings.colorTypeInfo, strings.colorType[widget.randomColor.type]!),
      //     _buildInfoItem(4, strings.rgbInfo, color_utils.toRGBString(color)),
      //     _buildInfoItem(5, strings.hsvInfo, color_utils.toHSVString(color)),
      //     _buildInfoItem(6, strings.hslInfo, color_utils.toHSLString(color)),
      //     _buildInfoItem(7, strings.decimalInfo, color_utils.toDecimalString(color)),
      //     _buildInfoItem(8, strings.luminanceInfo, color_utils.luminanceString(color)),
      //     _buildInfoItem(9, strings.brightnessInfo, color_utils.brightnessString(color)),
      //   ],
      // ),
    );
  }

  // /// Returns a color information list tile with the given [key] and [value].
  // Widget _buildInfoItem(int index, String key, String value) {
  //   return ListTile(
  //     onFocusChange: (hasFocus) {
  //       if (hasFocus) {
  //         setState(() {
  //           selectedInfoIndex = index;
  //         });
  //       }
  //     },
  //     onTap: () {
  //       setState(() {
  //         selectedInfoIndex = index;
  //       });
  //     },
  //     tileColor: selectedInfoIndex == index ? Colors.grey[300] : null,
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     title: Text(value, style: const TextStyle(fontSize: 20.0)),
  //     subtitle: Text(key),
  //     // trailing: IconButton(
  //     //   icon: const Icon(Icons.content_copy_outlined),
  //     //   onPressed: () => onCopyPressed?.call(key, value),
  //     // ),
  //     trailing: selectedInfoIndex == index
  //         ? Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               IconButton(
  //                 icon: const Icon(Icons.content_copy_outlined),
  //                 onPressed: () => widget.onCopyPressed?.call(key, value),
  //               ),
  //               IconButton(
  //                 icon: const Icon(Icons.share_outlined),
  //                 onPressed: () => widget.onCopyPressed?.call(key, value),
  //               ),
  //             ],
  //           )
  //         : null,
  //   );
  // }
}

class _ColorInfoItem extends StatelessWidget {
  const _ColorInfoItem({
    super.key, // ignore: unused_element
    required this.color,
    required this.infoKey,
    required this.infoValue,
    this.isSelected = false,
    required this.focusNode,
    this.onSelected,
    this.onCopyPressed,
    this.onSharePressed,
    this.onFocused,
  });

  final Color color;

  final String infoKey;

  final String infoValue;

  final bool isSelected;

  final FocusNode focusNode;

  final Function()? onSelected;

  final Function()? onCopyPressed;

  final Function()? onSharePressed;

  final Function()? onFocused;

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = color_utils.contrastColor(color);

    return ListTile(
      focusNode: focusNode,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // tileColor: isSelected ? contrastColor.withAlpha(50) : null,
      // selected: isSelected,
      focusColor: contrastColor.withAlpha(25),

      title: Text(infoValue, style: const TextStyle(fontSize: 20.0)),
      subtitle: Text(infoKey),
      // trailing: isSelected
      trailing: focusNode.hasPrimaryFocus
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.content_copy_outlined),
                  onPressed: onCopyPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: onSharePressed,
                ),
              ],
            )
          : null,
      // onFocusChange: (bool hasFocus) => hasFocus ? onSelected?.call() : null,
      // onFocusChange: (bool hasFocus) {
      //   if (hasFocus) {
      //     onFocused?.call();
      //   }
      // },
      onFocusChange: (bool hasFocus) {
        onFocused?.call();
      },
      // onTap: onSelected,
      onTap: () => focusNode.requestFocus(),

      // onTap: () {
      //   focusNode.requestFocus();

      //   onSelected?.call();
      // },
    );
  }
}
