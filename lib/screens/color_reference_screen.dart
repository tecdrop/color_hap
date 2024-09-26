// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/random_color_generators/random_named_color_generator.dart';
import '../models/random_color_generators/random_web_color_generator.dart';
import '../utils/color_utils.dart' as color_utils;

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.colorReferenceScreenTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: strings.webColorsTab),
            Tab(text: strings.namedColorsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _ColorReferenceListView(
            itemCount: () => kWebColors.length,
            itemData: (int index) {
              final MapEntry<int, String> entry = kWebColors.entries.elementAt(index);
              return (colorCode: entry.key, title: entry.value);
            },
          ),
          _ColorReferenceListView(
            itemCount: () => kNamedColors.length,
            itemData: (int index) {
              final MapEntry<int, String> entry = kNamedColors.entries.elementAt(index);
              return (colorCode: entry.key, title: entry.value);
            },
          ),
        ],
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
    return ListView.builder(
      itemCount: itemCount(),
      itemBuilder: (BuildContext context, int index) {
        final item = itemData(index);
        final Color itemColor = Color(item.colorCode);
        final String hexCode = color_utils.toHexString(itemColor);

        return ListTile(
          tileColor: itemColor,
          title: item.title != null ? Text(item.title!) : Text(hexCode),
          subtitle: Text(hexCode),
        );
      },
    );
  }
}
