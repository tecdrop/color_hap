// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

import '../common/consts.dart' as consts;
import '../common/preferences.dart' as preferences;
import '../common/strings.dart' as strings;
import '../models/random_color.dart';
import '../widgets/color_list_view.dart';
import '../widgets/confirmation_dialog_box.dart';

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
  /// Exports the favorite colors as a CSV file and uses the platform's share sheet to share it.
  void _exportFavorites() {
    final String favoritesCsv = preferences.colorFavoritesList.toCsvString();
    SharePlus.instance.share(
      ShareParams(
        fileNameOverrides: [consts.favoritesCSVFileName],
        files: [XFile.fromData(utf8.encode(favoritesCsv), mimeType: 'text/plain')],
      ),
    );
  }

  /// Clears all the favorite colors.
  void _clearFavorites() async {
    bool? showConfirmation = await showConfirmationDialogBox(
      context,
      title: strings.clearFavoritesDialogTitle,
      content: strings.clearFavoritesDialogMessage,
      positiveActionText: strings.clearFavoritesDialogPositiveAction,
    );
    if (showConfirmation == true) {
      setState(() => preferences.colorFavoritesList.clear());
    }
  }

  /// Performs the specified action on the app bar.
  Future<void> _onAppBarAction(_AppBarActions action) async {
    switch (action) {
      case _AppBarActions.exportFavoritesAsCsv:
        _exportFavorites();
        break;
      case _AppBarActions.clearFavorites:
        _clearFavorites();
        break;
    }
  }

  /// Deletes the favorite color at the given [index] from the list.
  ///
  /// Also displays a snackbar with an undo action.
  void _deleteFavoriteColor(int index) {
    // First remove the color from the list
    late final RandomColor randomColor;
    setState(() => randomColor = preferences.colorFavoritesList.removeAt(index));

    // Then display a snackbar with an undo action
    final snackBar = SnackBar(
      content: const Text(strings.removedFromFavorites),
      action: SnackBarAction(
        label: strings.undoRemoveFromFavorites,
        onPressed: () => setState(() => preferences.colorFavoritesList.insert(index, randomColor)),
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
          haveFavorites: preferences.colorFavoritesList.length > 0,
          onAction: _onAppBarAction,
        ),
        body: preferences.colorFavoritesList.length > 0
            ? _buildFavoritesListView()
            : _buildNoFavoritesMessage(),
      ),
    );
  }

  ColorListItemData _getItemData(int index) {
    final RandomColor randomColor = preferences.colorFavoritesList.elementAt(index);
    return (
      color: randomColor.color,
      title: randomColor.longTitle,
      subtitle: strings.randomColorType(randomColor.type),
    );
  }

  /// Builds the list of favorite colors.
  Widget _buildFavoritesListView() {
    return ColorListView(
      key: const PageStorageKey<String>('favoritesListView'),
      itemCount: () => preferences.colorFavoritesList.length,
      itemData: _getItemData,
      itemButton: (_) => (icon: Icons.delete, tooltip: strings.removeFavTooltip),
      onItemTap: (int index) => Navigator.of(
        context,
      ).pop<RandomColor>(preferences.colorFavoritesList.elementAt(index)),
      onItemButtonPressed: _deleteFavoriteColor,
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
enum _AppBarActions { clearFavorites, exportFavoritesAsCsv }

/// The app bar of the Color Info screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element_parameter
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
