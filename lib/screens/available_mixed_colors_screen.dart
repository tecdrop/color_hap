// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/color_type.dart';
import '../models/random_color.dart';
import '../utils/utils.dart' as utils;
import 'available_colors_screen.dart';

class AvailableMixedColorsScreen extends StatelessWidget {
  const AvailableMixedColorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.availableMixedColorScreenTitle),
      ),
      body: ListView(
        children: const <Widget>[
          AvailableColorsLink(colorType: ColorType.basicColor),
          AvailableColorsLink(colorType: ColorType.webColor),
          AvailableColorsLink(colorType: ColorType.namedColor),
          AvailableColorsLink(colorType: ColorType.attractiveColor),
          AvailableColorsLink(colorType: ColorType.trueColor),
        ],
      ),
    );
  }
}

class AvailableColorsLink extends StatelessWidget {
  const AvailableColorsLink({
    super.key,
    required this.colorType,
  });

  /// The type of available colors to display.
  final ColorType colorType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(strings.availableColors(colorType)),
      onTap: () async {
        // utils.navigateTo(context, AvailableColorsScreen(colorType: colorType));
        final NavigatorState navigator = Navigator.of(context);
        final RandomColor? randomColor = await utils.navigateTo<RandomColor>(
          context,
          AvailableColorsScreen(colorType: colorType),
        );
        navigator.pop<RandomColor>(randomColor);
      },
    );
  }
}
