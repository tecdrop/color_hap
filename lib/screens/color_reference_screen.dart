// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/color_type.dart';
import '../models/random_color_generators/random_basic_color_generator.dart';
import '../models/random_color_generators/random_named_color_generator.dart';
import '../models/random_color_generators/random_web_color_generator.dart';
import '../models/random_color_generators/random_true_color_generator.dart' as rtcg;
import '../utils/color_utils.dart' as color_utils;

/// The storage bucket used to store the scroll position of the color reference list views.
final PageStorageBucket colorReferenceBucket = PageStorageBucket();

class ColorReferenceScreen extends StatefulWidget {
  const ColorReferenceScreen({super.key});

  @override
  State<ColorReferenceScreen> createState() => _ColorReferenceScreenState();
}

class _ColorReferenceScreenState extends State<ColorReferenceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use PageStorage to store the scroll position of the list views while the app is running
    return PageStorage(
      bucket: colorReferenceBucket,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(strings.colorReferenceScreenTitle),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Tab>[
              Tab(text: strings.colorTypeReferenceTabs[ColorType.basicColor]!),
              Tab(text: strings.colorTypeReferenceTabs[ColorType.webColor]!),
              Tab(text: strings.colorTypeReferenceTabs[ColorType.namedColor]!),
              Tab(text: strings.colorTypeReferenceTabs[ColorType.trueColor]!),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _ColorReferenceListView(
              key: const PageStorageKey<ColorType>(ColorType.basicColor),
              itemCount: () => kBasicColors.length,
              itemData: (int index) {
                final MapEntry<int, String> entry = kBasicColors.entries.elementAt(index);
                return (colorCode: entry.key, title: entry.value);
              },
            ),
            _ColorReferenceListView(
              key: const PageStorageKey<ColorType>(ColorType.webColor),
              itemCount: () => kWebColors.length,
              itemData: (int index) {
                final MapEntry<int, String> entry = kWebColors.entries.elementAt(index);
                return (colorCode: entry.key, title: entry.value);
              },
            ),
            _ColorReferenceListView(
              key: const PageStorageKey<ColorType>(ColorType.namedColor),
              itemCount: () => kNamedColors.length,
              itemData: (int index) {
                final MapEntry<int, String> entry = kNamedColors.entries.elementAt(index);
                return (colorCode: entry.key, title: entry.value);
              },
            ),
            _ColorReferenceListView(
              key: const PageStorageKey<ColorType>(ColorType.trueColor),
              itemCount: () => rtcg.possibilityCount,
              itemData: (int index) {
                final int colorCode = color_utils.withFullAlpha(index);
                return (colorCode: colorCode, title: null);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorReferenceListView extends StatelessWidget {
  const _ColorReferenceListView({
    super.key, // ignore: unused_element
    required this.itemCount,
    required this.itemData,
  });

  /// A callback function that returns the number of items to display in the list.
  final int Function() itemCount;

  /// A callback function that returns the color code and title for each item in the list.
  final ({int colorCode, String? title}) Function(int index) itemData;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: itemCount(),
      itemBuilder: (BuildContext context, int index) {
        final item = itemData(index);
        final Color itemColor = Color(item.colorCode);
        final Color contrastColor = color_utils.contrastColor(itemColor);
        final String hexCode = color_utils.toHexString(itemColor);

        return ListTile(
          // Use padding to constrain the width of the list items so they look ok on large screens
          contentPadding: EdgeInsets.symmetric(
            horizontal: max(16.0, (width - 1024) / 2),
            vertical: 32.0,
          ),

          tileColor: itemColor,
          textColor: contrastColor,
          title: item.title != null ? Text(item.title!) : Text(hexCode),
          subtitle: item.title != null ? Text(hexCode) : null,
        );
      },
      // separatorBuilder: (BuildContext context, int index) => const Divider(),
      // separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 0.0),
    );
  }
}
