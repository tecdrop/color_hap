// Copyright 2020-2024 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by a user license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../common/app_routes.dart';
import '../../common/app_settings.dart' as settings;
import '../../common/app_urls.dart' as urls;
import '../../common/custom_icons.dart' as custom_icons;
import '../../common/ui_strings.dart' as strings;
import '../../models/color_type.dart';
import '../../models/random_color_generator.dart';
import '../../models/random_color.dart';
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
  colorFavorites,
  help,
  viewSource,
  rateApp,
}

/// The main Material Design drawer of the app, with the main app functions.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.randomColor,
    required this.colorType,
    this.onShouldUpdateState,
  });

  /// The current random color.
  final RandomColor randomColor;

  /// The current type of random colors generated in the Random Color screen.
  final ColorType colorType;

  /// A callback function that is called when the the screen that opened the drawer should update.
  final void Function()? onShouldUpdateState;

  /// Starts a specific functionality of the app when the user taps a drawer [item].
  void _onItemTap(BuildContext context, AppDrawerItems item) {
    switch (item) {
      // Launch the external RGB Color Wallpaper Pro url
      case AppDrawerItems.setWallpaper:
        Navigator.pop(context);
        utils.launchUrlExternal(context, urls.setWallpaper);
        break;

      // Reopen the Random Color screen for generating random colors (of any type)
      case AppDrawerItems.randomMixedColor:
        Navigator.pop(context);
        gotoRandomColorRoute(context, ColorType.mixedColor);
        break;

      // Reopen the Random Color screen for generating random basic colors
      case AppDrawerItems.randomBasicColor:
        Navigator.pop(context);
        gotoRandomColorRoute(context, ColorType.basicColor);
        break;

      // Reopen the Random Color screen for generating random web colors
      case AppDrawerItems.randomWebColor:
        Navigator.pop(context);
        gotoRandomColorRoute(context, ColorType.webColor);
        break;

      // Reopen the Random Color screen for generating random named colors
      case AppDrawerItems.randomNamedColor:
        Navigator.pop(context);
        gotoRandomColorRoute(context, ColorType.namedColor);
        break;

      // Reopen the Random Color screen for generating random attractive colors
      case AppDrawerItems.randomAttractiveColor:
        Navigator.pop(context);
        gotoRandomColorRoute(context, ColorType.attractiveColor);
        break;

      // Reopen the Random Color screen for generating random true colors
      case AppDrawerItems.randomTrueColor:
        Navigator.pop(context);
        gotoRandomColorRoute(context, ColorType.trueColor);
        break;

      // Open the Color Info screen with the current random color
      case AppDrawerItems.colorInfo:
        Navigator.pop(context);
        gotoColorInfoRoute(context, randomColor);
        break;

      // Open the Color Preview screen with the current random color
      case AppDrawerItems.colorPreview:
        Navigator.pop(context);
        gotoColorPreviewRoute(context, randomColor.color);
        break;

      // Open the Color Favorites screen
      case AppDrawerItems.colorFavorites:
        (() async {
          Navigator.pop(context);
          await gotoColorFavoritesRoute(context);
          onShouldUpdateState?.call();
        }());
        break;

      // Launch the external Online Help url
      case AppDrawerItems.help:
        Navigator.pop(context);
        utils.launchUrlExternal(context, urls.help);
        break;

      // Launch the external View Source url
      case AppDrawerItems.viewSource:
        Navigator.pop(context);
        utils.launchUrlExternal(context, urls.viewSource);
        break;

      // Launch the external Rate App url
      case AppDrawerItems.rateApp:
        Navigator.pop(context);
        utils.launchUrlExternal(context, urls.getRateUrl());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simply a convenience function that returns a string with the number of possibilities.
    String possibilities(ColorType colorType) => strings
        .possibilitiesDrawerSubtitle(utils.intToCommaSeparatedString(possibilityCount(colorType)));

    return Drawer(
      child: ListView(
        children: <Widget>[
          // The app drawer header with a bottom margin
          _AppDrawerHeader(color: randomColor.color),
          const SizedBox(height: 16.0),

          // The Set Color Wallpaper drawer item
          ListTile(
            leading: const Icon(Icons.wallpaper_rounded),
            title: const Text(strings.setWallpaperDrawer),
            subtitle: const Text(strings.setWallpaperDrawerSubtitle),
            isThreeLine: true,
            onTap: () => _onItemTap(context, AppDrawerItems.setWallpaper),
          ),

          const Divider(),

          // All Random Colors drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.mixedColor
                ? Icons.looks_one_rounded
                : Icons.looks_one_outlined,
            title: strings.randomMixedColorDrawer,
            subtitle: possibilities(ColorType.mixedColor),
            item: AppDrawerItems.randomMixedColor,
          ),

          // Random Basic Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.basicColor
                ? Icons.looks_two_rounded
                : Icons.looks_two_outlined,
            title: strings.randomBasicColorDrawer,
            subtitle: possibilities(ColorType.basicColor),
            item: AppDrawerItems.randomBasicColor,
          ),

          // Random Web Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.webColor ? Icons.looks_3_rounded : Icons.looks_3_outlined,
            title: strings.randomWebColorDrawer,
            subtitle: possibilities(ColorType.webColor),
            item: AppDrawerItems.randomWebColor,
          ),

          // Random Named Color drawer item
          _buildItem(
            context,
            icon:
                colorType == ColorType.namedColor ? Icons.looks_4_rounded : Icons.looks_4_outlined,
            title: strings.randomNamedColorDrawer,
            subtitle: possibilities(ColorType.namedColor),
            item: AppDrawerItems.randomNamedColor,
          ),

          // Random Attractive Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.attractiveColor
                ? Icons.looks_5_rounded
                : Icons.looks_5_outlined,
            title: strings.randomAttractiveColorDrawer,
            subtitle: strings.randomAttractiveColorDrawerSubtitle,
            item: AppDrawerItems.randomAttractiveColor,
          ),

          // Random True Color drawer item
          _buildItem(
            context,
            icon: colorType == ColorType.trueColor ? Icons.looks_6_rounded : Icons.looks_6_outlined,
            title: strings.randomTrueColorDrawer,
            subtitle: possibilities(ColorType.trueColor),
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

          // Color Favorites drawer item
          _buildItem(
            context,
            icon: Icons.favorite_outline_outlined,
            title: strings.colorFavoritesDrawer,
            subtitle: strings.colorFavoritesSubtitle(
              utils.intToCommaSeparatedString(settings.colorFavoritesList.length),
              isPlural: settings.colorFavoritesList.length != 1,
            ),
            item: AppDrawerItems.colorFavorites,
          ),

          const Divider(),

          // Help & Support drawer item
          _buildItem(
            context,
            icon: Icons.support_outlined,
            title: strings.helpDrawer,
            item: AppDrawerItems.help,
          ),

          // View Source drawer item
          _buildItem(
            context,
            icon: custom_icons.github,
            title: strings.sourceCodeDrawer,
            subtitle: strings.sourceCodeDrawerSubtitle,
            item: AppDrawerItems.viewSource,
          ),

          // Rate App drawer item
          _buildItem(
            context,
            // icon: Icons.thumb_up_alt_outlined,
            icon: Icons.star_rate,
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
      onTap: () => _onItemTap(context, item),
      selected: selected,
    );
  }
}

/// The app drawer header.
///
/// It is filled with a background color, and displays the app name.
class _AppDrawerHeader extends StatelessWidget {
  const _AppDrawerHeader({
    // ignore: unused_element
    super.key,
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
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: color_utils.contrastColor(color),
              ),
        ),
      ),
    );
  }
}
