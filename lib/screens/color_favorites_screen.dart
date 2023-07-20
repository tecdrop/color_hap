// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/app_routes.dart';
import '../common/app_settings.dart' as app_settings;
import '../models/random_color.dart';

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
          title: const Text('Favorites'),
        ),
        body: ListView.builder(
          itemCount: app_settings.colorFavoritesList.length,
          itemBuilder: (BuildContext context, int index) {
            RandomColor randomColor = app_settings.colorFavoritesList.elementAt(index);
            return ListTile(
              tileColor: randomColor.color,
              title: Text(randomColor.title),
              onTap: () {
                gotoGivenColorRoute(context, randomColor);
              },
            );
          },
        ));
  }
}
