// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/app_routes.dart';
import '../common/app_settings.dart' as settings;
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../widgets/color_favorite_list_item.dart';

class ColorFavoritesScreen extends StatefulWidget {
  const ColorFavoritesScreen({super.key});

  @override
  State<ColorFavoritesScreen> createState() => _ColorFavoritesScreenState();
}

class _ColorFavoritesScreenState extends State<ColorFavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.favoriteColorsScreenTitle),
      ),
      body: settings.colorFavoritesList.length > 0
          ? _buildFavoritesListView()
          : _buildNoFavoritesMessage(),
    );
  }

  Widget _buildFavoritesListView() {
    return ListView.builder(
      itemCount: settings.colorFavoritesList.length,
      itemBuilder: (BuildContext context, int index) {
        RandomColor randomColor = settings.colorFavoritesList.elementAt(index);
        return ColorFavoriteListItem(
          randomColor: randomColor,
          onTap: () => gotoColorInfoRoute(context, randomColor, fromFav: true),
          onDeletePressed: () {
            setState(() {
              settings.colorFavoritesList.removeAt(index);
            });
          },
        );
      },
    );
  }

  /// Builds a message to display when there are no favorite colors.
  Widget _buildNoFavoritesMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.favorite_border, size: 64),
          const SizedBox(height: 16),
          Text(
            strings.noFavoritesMessage,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
