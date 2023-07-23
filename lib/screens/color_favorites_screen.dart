// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/app_routes.dart';
import '../common/app_settings.dart' as settings;
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../widgets/color_favorite_list_item.dart';
import '../widgets/confirmation_dialog_box.dart';

/// The Color Favorites screen.
///
/// Displays the list of favorite colors. The user can tap on a color to view its information, or
/// remove it from the list. The user can also clear the entire list.
class ColorFavoritesScreen extends StatefulWidget {
  const ColorFavoritesScreen({super.key});

  @override
  State<ColorFavoritesScreen> createState() => _ColorFavoritesScreenState();
}

class _ColorFavoritesScreenState extends State<ColorFavoritesScreen> {
  /// Performs the specified action on the app bar.
  Future<void> _onAppBarAction(_AppBarActions action) async {
    switch (action) {
      // Clears all the favorite colors
      case _AppBarActions.clearAll:
        if (await showConfirmationDialogBox(
              context,
              title: strings.clearFavoritesDialogTitle,
              content: strings.clearFavoritesDialogMessage,
              positiveActionText: strings.clearFavoritesDialogPositiveAction,
            ) ==
            true) {
          setState(() {
            settings.colorFavoritesList.clear();
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        title: const Text(strings.favoriteColorsScreenTitle),
        onAction: _onAppBarAction,
      ),
      body: settings.colorFavoritesList.length > 0
          ? _buildFavoritesListView()
          : _buildNoFavoritesMessage(),
    );
  }

  /// Builds the list of favorite colors.
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
          const Icon(Icons.favorite_border, size: 32),
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

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  clearAll,
}

/// The app bar of the Color Info screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    Key? key,
    required this.title,
    required this.onAction,
  }) : super(key: key);

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action) onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,

      // The common operations displayed in this app bar
      actions: <Widget>[
        // Add the Popup Menu items
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppBarActions>>[
            // The web search action
            const PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.clearAll,
              child: Text(strings.clearFavorites),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
