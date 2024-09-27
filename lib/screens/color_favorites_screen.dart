// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../common/app_settings.dart' as settings;
import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/utils.dart' as utils;
import '../widgets/color_favorite_list_item.dart';
import '../widgets/confirmation_dialog_box.dart';
import 'color_info_screen.dart';

/// The storage bucket used to store the scroll position of the list of favorite colors.
final PageStorageBucket colorReferenceBucket = PageStorageBucket();

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
      // Exports the favorite colors as a CSV file
      case _AppBarActions.exportFavoritesAsCsv:
        ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
        await utils.copyToClipboard(context, settings.colorFavoritesList.toCsvString());
        utils.showSnackBarForAsync(messengerState, strings.favoritesExported);
        break;
      // Clears all the favorite colors
      case _AppBarActions.clearFavorites:
        bool? showConfirmation = await showConfirmationDialogBox(
          context,
          title: strings.clearFavoritesDialogTitle,
          content: strings.clearFavoritesDialogMessage,
          positiveActionText: strings.clearFavoritesDialogPositiveAction,
        );
        if (showConfirmation == true) {
          setState(() => settings.colorFavoritesList.clear());
        }
        break;
    }
  }

  /// Deletes the favorite color at the given [index] from the list.
  ///
  /// Also displays a snackbar with an undo action.
  void _deleteFavoriteColor(int index) {
    // First remove the color from the list
    late final RandomColor randomColor;
    setState(() => randomColor = settings.colorFavoritesList.removeAt(index));

    // Then display a snackbar with an undo action
    final snackBar = SnackBar(
      content: const Text(strings.removedFromFavorites),
      action: SnackBarAction(
        label: strings.undoRemoveFromFavorites,
        onPressed: () => setState(() => settings.colorFavoritesList.insert(index, randomColor)),
      ),
    );
    ScaffoldMessenger.of(context)
      // The user may delete multiple colors in a row, so remove any existing snackbar before
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // Use a [PageStorage] widget to store / restore the scroll position of the favorites list view
    // while the app is running.
    return PageStorage(
      bucket: colorReferenceBucket,
      child: Scaffold(
        appBar: _AppBar(
          title: const Text(strings.favoriteColorsScreenTitle),
          haveFavorites: settings.colorFavoritesList.length > 0,
          onAction: _onAppBarAction,
        ),
        body: settings.colorFavoritesList.length > 0
            ? _buildFavoritesListView()
            : _buildNoFavoritesMessage(),
      ),
    );
  }

  /// Builds the list of favorite colors.
  Widget _buildFavoritesListView() {
    return ListView.builder(
      key: const PageStorageKey<String>('favoritesListView'),
      itemCount: settings.colorFavoritesList.length,
      itemBuilder: (BuildContext context, int index) {
        // Build a list item for each favorite color
        RandomColor randomColor = settings.colorFavoritesList.elementAt(index);
        return ColorFavoriteListItem(
          randomColor: randomColor,
          onTap: () => utils.navigateTo(context, ColorInfoScreen(randomColor: randomColor)),
          // onTap: () => gotoColorInfoRoute(context, randomColor, fromFav: true),
          onDeletePressed: () => _deleteFavoriteColor(index),
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
          Text(
            strings.noFavoritesMessage,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          const Icon(Icons.favorite_border, size: 32.0),
        ],
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  clearFavorites,
  exportFavoritesAsCsv,
}

/// The app bar of the Color Info screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    // ignore: unused_element
    super.key,
    required this.title,
    required this.onAction,
    this.haveFavorites = true,
  });

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// Whether the clear favorites action is enabled.
  final bool haveFavorites;

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
            // The export as CSV action
            PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.exportFavoritesAsCsv,
              enabled: haveFavorites,
              child: const Text(strings.exportFavoritesAsCsv),
            ),
            const PopupMenuDivider(),
            // The clear favorites action
            PopupMenuItem<_AppBarActions>(
              value: _AppBarActions.clearFavorites,
              enabled: haveFavorites,
              child: const Text(strings.clearFavorites),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
