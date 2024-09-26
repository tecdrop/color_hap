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

  @override
  Widget build(BuildContext context) {
    // Use PageStorage to store the scroll position of the list views while the app is running
    return PageStorage(
      bucket: _storageBucket,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.availableColors(colorType)),
        ),
        body: switch (colorType) {
          ColorType.mixedColor => const SizedBox.shrink(), // TODO: Implement mixed colors?
          ColorType.basicColor => const _BasicColorsListView(),
          ColorType.webColor => const _WebColorsListView(),
          ColorType.namedColor => const _NamedColorsListView(),
          ColorType.attractiveColor =>
            const SizedBox.shrink(), // TODO: Implement attractive colors?
          ColorType.trueColor => const _TrueColorsListView(),
        },
      ),
    );
  }
}

/// A list view of all the available basic colors.
class _BasicColorsListView extends StatelessWidget {
  const _BasicColorsListView({super.key}); // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    return AvailableColorsListView(
      key: const PageStorageKey<ColorType>(ColorType.basicColor),
      itemCount: () => rbcg.kBasicColors.length,
      itemData: (int index) {
        final MapEntry<int, String> entry = rbcg.kBasicColors.entries.elementAt(index);
        return (colorCode: entry.key, title: entry.value);
      },
    );
  }
}

/// A list view of all the available web colors.
class _WebColorsListView extends StatelessWidget {
  const _WebColorsListView({super.key}); // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    return AvailableColorsListView(
      key: const PageStorageKey<ColorType>(ColorType.webColor),
      itemCount: () => rwcg.kWebColors.length,
      itemData: (int index) {
        final MapEntry<int, String> entry = rwcg.kWebColors.entries.elementAt(index);
        return (colorCode: entry.key, title: entry.value);
      },
    );
  }
}

/// A list view of all the available named colors.
class _NamedColorsListView extends StatelessWidget {
  const _NamedColorsListView({super.key}); // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    return AvailableColorsListView(
      key: const PageStorageKey<ColorType>(ColorType.namedColor),
      itemCount: () => rncg.kNamedColors.length,
      itemData: (int index) {
        final MapEntry<int, String> entry = rncg.kNamedColors.entries.elementAt(index);
        return (colorCode: entry.key, title: entry.value);
      },
    );
  }
}

/// A list view of all the available true colors.
class _TrueColorsListView extends StatelessWidget {
  const _TrueColorsListView({super.key}); // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    return AvailableColorsListView(
      key: const PageStorageKey<ColorType>(ColorType.trueColor),
      itemCount: () => rtcg.possibilityCount,
      itemData: (int index) {
        final int colorCode = color_utils.withFullAlpha(index);
        return (colorCode: colorCode, title: null);
      },
    );
  }
}
