// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../../common/preferences.dart' as preferences;
import '../../common/strings.dart' as strings;
import '../../models/color_item.dart';
import '../../models/color_type.dart';
import '../../utils/color_utils.dart' as color_utils;
import '../../utils/utils.dart' as utils;

/// The items that appear in the app drawer.
enum AppDrawerItems {
  setWallpaper,
  randomMixedColor,
  randomBasicColor,
  randomWebColor,
  randomNamedColor,
  randomAttractiveColor,
  randomTrueColor,
  colorInfo,
  colorPreview,
  colorShades,
  availableColors,
  favoriteColors,
  help,
  viewSource,
  rateApp,
}

/// The main Material Design drawer of the app, with the main app functions.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.colorItem,
    required this.colorType,
    required this.possibilityCount,
    this.onItemTap,
  });

  /// The current random color.
  final ColorItem colorItem;

  /// The current type of random colors generated in the Random Color screen.
  final ColorType colorType;

  /// A map with the number of possible random colors for each color type.
  final Map<ColorType, int> possibilityCount;

  /// A callback function that is called when the user taps an app drawer item.
  final void Function(AppDrawerItems)? onItemTap;

  /// A convenience function that returns a string with the number of possibilities.
  String? _possibilities(ColorType colorType) {
    int? count = possibilityCount[colorType];
    return count != null
        ? strings.possibilitiesDrawerSubtitle(utils.intToCommaSeparatedString(count))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // The app drawer header with a bottom margin
          _AppDrawerHeader(color: colorItem.color),
          const SizedBox(height: 16.0),

          // The Set Color Wallpaper drawer item
          ListTile(
            leading: const Icon(Icons.wallpaper_rounded),
            title: const Text(strings.setWallpaperDrawer),
            subtitle: const Text(strings.setWallpaperDrawerSubtitle),
            isThreeLine: true,
            onTap: () => onItemTap?.call(AppDrawerItems.setWallpaper),
          ),

          const Divider(),

          // All Random Colors drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.mixedColor
                ? Icons.looks_one_rounded
                : Icons.looks_one_outlined,
            title: strings.randomMixedColorDrawer,
            subtitle: _possibilities(ColorType.mixedColor),
            item: AppDrawerItems.randomMixedColor,
          ),

          // Random Basic Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.basicColor
                ? Icons.looks_two_rounded
                : Icons.looks_two_outlined,
            title: strings.randomBasicColorDrawer,
            subtitle: _possibilities(ColorType.basicColor),
            item: AppDrawerItems.randomBasicColor,
          ),

          // Random Web Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.webColor ? Icons.looks_3_rounded : Icons.looks_3_outlined,
            title: strings.randomWebColorDrawer,
            subtitle: _possibilities(ColorType.webColor),
            item: AppDrawerItems.randomWebColor,
          ),

          // Random Named Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.namedColor
                ? Icons.looks_4_rounded
                : Icons.looks_4_outlined,
            title: strings.randomNamedColorDrawer,
            subtitle: _possibilities(ColorType.namedColor),
            item: AppDrawerItems.randomNamedColor,
          ),

          // Random Attractive Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.attractiveColor
                ? Icons.looks_5_rounded
                : Icons.looks_5_outlined,
            title: strings.randomAttractiveColorDrawer,
            subtitle: _possibilities(ColorType.attractiveColor),
            item: AppDrawerItems.randomAttractiveColor,
          ),

          // Random True Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.trueColor ? Icons.looks_6_rounded : Icons.looks_6_outlined,
            title: strings.randomTrueColorDrawer,
            subtitle: _possibilities(ColorType.trueColor),
            item: AppDrawerItems.randomTrueColor,
          ),

          const Divider(),

          // Color Info drawer item
          _buildItem(
            context,
            icon: Icons.info_outline,
            title: strings.colorInfoDrawer,
            item: AppDrawerItems.colorInfo,
          ),

          // Color Preview drawer item
          _buildItem(
            context,
            icon: Icons.remove_red_eye_outlined,
            title: strings.colorPreviewDrawer,
            item: AppDrawerItems.colorPreview,
          ),

          // Color Shades drawer item
          _buildItem(
            context,
            // icon: Icons.gradient_outlined,
            icon: Icons.tonality_outlined,
            title: strings.colorShadesDrawer,
            item: AppDrawerItems.colorShades,
          ),

          // Available Colors drawer item
          _buildItem(
            context,
            // icon: Icons.palette_outlined,
            icon: Icons.list_alt_outlined,
            title: strings.availableColorsDrawer,
            item: AppDrawerItems.availableColors,
          ),

          // Color Favorites drawer item
          _buildItem(
            context,
            icon: preferences.colorFavoritesList.length > 0
                ? Icons.favorite
                : Icons.favorite_border,
            title: strings.colorFavoritesDrawer,
            subtitle: strings.colorFavoritesSubtitle(
              utils.intToCommaSeparatedString(preferences.colorFavoritesList.length),
              isPlural: preferences.colorFavoritesList.length != 1,
            ),
            item: AppDrawerItems.favoriteColors,
          ),

          const Divider(),

          // Help & Support drawer item
          _buildItem(
            context,
            icon: Icons.support_outlined,
            title: strings.helpDrawer,
            item: AppDrawerItems.help,
          ),

          // Source code (Star on GitHub) drawer item
          _buildItem(
            context,
            icon: Icons.star,
            title: strings.sourceCodeDrawer,
            subtitle: strings.sourceCodeDrawerSubtitle,
            item: AppDrawerItems.viewSource,
          ),

          // Rate App drawer item
          _buildItem(
            context,
            icon: Icons.thumb_up,
            title: strings.rateAppDrawer,
            item: AppDrawerItems.rateApp,
          ),
        ],
      ),
    );
  }

  /// Creates an app drawer item, with an optional [icon], a [title], and an optional [subtitle].
  Widget _buildItem(
    BuildContext context, {
    IconData? icon,
    required String title,
    String? subtitle,
    required AppDrawerItems item,
    bool selected = false,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: () => onItemTap?.call(item),
      selected: selected,
    );
  }
}

/// The app drawer header.
///
/// It is filled with a background color, and displays the app name.
class _AppDrawerHeader extends StatelessWidget {
  const _AppDrawerHeader({
    super.key, // ignore: unused_element_parameter
    required this.color,
  });

  /// The color to fill in the background of the drawer header.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(color: color),
      child: Center(
        child: Text(
          strings.appName,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(color: color_utils.contrastColor(color)),
        ),
      ),
    );
  }
}
