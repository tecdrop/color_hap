// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/color_utils.dart';

class ColorFavoriteListItem extends StatelessWidget {
  const ColorFavoriteListItem({
    super.key,
    required this.randomColor,
    this.onTap,
    this.onDeletePressed,
  });

  /// The random color to display.
  final RandomColor randomColor;

  final void Function()? onTap;

  final void Function()? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = ColorUtils.contrastOf(randomColor.color);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      tileColor: randomColor.color,
      textColor: contrastColor,
      // title: Text(randomColor.title),
      // title: Text(randomColor.title, style: const TextStyle(fontSize: 22.0)),
      title: Text(randomColor.title, style: const TextStyle(fontSize: 20.0)),
      subtitle: Text(strings.colorType[randomColor.type]!),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: contrastColor),
        tooltip: strings.removeFavTooltip,
        onPressed: onDeletePressed,
      ),
      onTap: onTap,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final Color contrastColor = ColorUtils.contrastOf(randomColor.color);

  //   final TextStyle largeTextStyle =
  //       Theme.of(context).textTheme.headlineSmall!.copyWith(color: contrastColor);
  //   final TextStyle smallTextStyle =
  //       Theme.of(context).textTheme.titleSmall!.copyWith(color: contrastColor);

  //   return Container(
  //     color: randomColor.color,
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (randomColor.name != null) Text(randomColor.name!, style: largeTextStyle),
  //         Text(ColorUtils.toHexString(randomColor.color), style: largeTextStyle),
  //         Text(strings.colorType[randomColor.type]!, style: smallTextStyle),
  //         const SizedBox(height: 16),
  //         IconButton(
  //           icon: Icon(Icons.delete, color: contrastColor),
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
