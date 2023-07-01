// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by a user license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_const.dart';
import '../../common/app_urls.dart';
import '../../common/ui_strings.dart';
import '../../models/random_color_generator.dart';
import '../../models/random_color.dart';
import '../../utils/color_utils.dart';
import '../../utils/utils.dart';

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
  previewColor,
  help,
  viewSource,
  rateApp,
}

/// The main Material Design drawer of the app, with the main app functions.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.randomColor,
    required this.colorType,
  }) : super(key: key);

  /// The current random color.
  final RandomColor randomColor;

  /// The current type of random colors generated in the Random Color screen.
  final ColorType colorType;

  /// Starts a specific functionality of the app when the user taps a drawer [item].
  void _onItemTap(BuildContext context, AppDrawerItems item) {
    // A convenience function to reopen the Random Color screen for generating a new type of random
    // colors. Called by the four random color drawer items.
    void reopenRandomScreen(BuildContext context, ColorType colorType) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AppConst.randomColorRoute, arguments: colorType);
    }

    switch (item) {
      // Launch the external RGB Color Wallpaper Pro url
      case AppDrawerItems.setWallpaper:
        Navigator.pop(context);
        Utils.launchUrlExternal(context, AppUrls.setWallpaper);
        break;

      // Reopen the Random Color screen for generating random colors (of any type)
      case AppDrawerItems.randomMixedColor:
        reopenRandomScreen(context, ColorType.mixedColor);
        break;

      // Reopen the Random Color screen for generating random basic colors
      case AppDrawerItems.randomBasicColor:
        reopenRandomScreen(context, ColorType.basicColor);
        break;

      // Reopen the Random Color screen for generating random web colors
      case AppDrawerItems.randomWebColor:
        reopenRandomScreen(context, ColorType.webColor);
        break;

      // Reopen the Random Color screen for generating random named colors
      case AppDrawerItems.randomNamedColor:
        reopenRandomScreen(context, ColorType.namedColor);
        break;

      // Reopen the Random Color screen for generating random attractive colors
      case AppDrawerItems.randomAttractiveColor:
        reopenRandomScreen(context, ColorType.attractiveColor);
        break;

      // Reopen the Random Color screen for generating random true colors
      case AppDrawerItems.randomTrueColor:
        reopenRandomScreen(context, ColorType.trueColor);
        break;

      // Open the Color Information screen with the current color
      case AppDrawerItems.colorInfo:
        Navigator.pop(context);
        Navigator.pushNamed(context, AppConst.colorInfoRoute, arguments: randomColor);
        break;

      // Open the Preview Color screen with the current color
      case AppDrawerItems.previewColor:
        Navigator.pop(context);
        final String colorCode = ColorUtils.toHexString(randomColor.color, withHash: false);
        context.go('/${AppConst.previewColorRoute}/$colorCode');
        break;

      // Launch the external Online Help url
      case AppDrawerItems.help:
        Navigator.pop(context);
        Utils.launchUrlExternal(context, AppUrls.help);
        break;

      // Launch the external View Source url
      case AppDrawerItems.viewSource:
        Navigator.pop(context);
        Utils.launchUrlExternal(context, AppUrls.viewSource);
        break;

      // Launch the external Rate App url
      case AppDrawerItems.rateApp:
        Navigator.pop(context);
        Utils.launchUrlExternal(context, AppUrls.rate);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simply a convenience function that returns a string with the number of possibilities.
    String possibilities(ColorType colorType) => UIStrings.possibilitiesDrawerSubtitle(
        Utils.intToCommaSeparatedString(possibilityCount(colorType)));

    return Drawer(
      child: ListView(
        children: <Widget>[
          _AppDrawerHeader(color: randomColor.color),

          // The Set Color Wallpaper drawer item
          ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            tileColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.075),
            leading: const Icon(Icons.wallpaper_rounded),
            title: const Text(UIStrings.setWallpaperDrawer),
            subtitle: const Text(UIStrings.setWallpaperDrawerSubtitle),
            isThreeLine: true,
            onTap: () => _onItemTap(context, AppDrawerItems.setWallpaper),
          ),

          const Divider(),

          // All Random Colors drawer item
          _buildItem(
            context,
            icon: Icons.looks_one_rounded,
            title: UIStrings.randomMixedColorDrawer,
            subtitle: possibilities(ColorType.mixedColor),
            item: AppDrawerItems.randomMixedColor,
            selected: colorType == ColorType.mixedColor,
          ),

          // Random Basic Color drawer item
          _buildItem(
            context,
            icon: Icons.looks_two_rounded,
            title: UIStrings.randomBasicColorDrawer,
            subtitle: possibilities(ColorType.basicColor),
            item: AppDrawerItems.randomBasicColor,
            selected: colorType == ColorType.basicColor,
          ),

          // Random Web Color drawer item
          _buildItem(
            context,
            icon: Icons.looks_3_rounded,
            title: UIStrings.randomWebColorDrawer,
            subtitle: possibilities(ColorType.webColor),
            item: AppDrawerItems.randomWebColor,
            selected: colorType == ColorType.webColor,
          ),

          // Random Named Color drawer item
          _buildItem(
            context,
            icon: Icons.looks_4_rounded,
            title: UIStrings.randomNamedColorDrawer,
            subtitle: possibilities(ColorType.namedColor),
            item: AppDrawerItems.randomNamedColor,
            selected: colorType == ColorType.namedColor,
          ),

          // Random Attractive Color drawer item
          _buildItem(
            context,
            icon: Icons.looks_5_rounded,
            title: UIStrings.randomAttractiveColorDrawer,
            subtitle: UIStrings.randomAttractiveColorDrawerSubtitle,
            item: AppDrawerItems.randomAttractiveColor,
            selected: colorType == ColorType.attractiveColor,
          ),

          // Random True Color drawer item
          _buildItem(
            context,
            icon: Icons.looks_6_rounded,
            title: UIStrings.randomTrueColorDrawer,
            subtitle: possibilities(ColorType.trueColor),
            item: AppDrawerItems.randomTrueColor,
            selected: colorType == ColorType.trueColor,
          ),

          const Divider(),

          // Color Information drawer item
          _buildItem(
            context,
            icon: Icons.info_rounded,
            title: UIStrings.colorInfoDrawer,
            item: AppDrawerItems.colorInfo,
          ),

          // Preview Color drawer item
          _buildItem(
            context,
            icon: Icons.preview_rounded,
            title: UIStrings.previewColorDrawer,
            item: AppDrawerItems.previewColor,
          ),

          const Divider(),

          // Help & Support drawer item
          _buildItem(
            context,
            icon: Icons.support_rounded,
            title: UIStrings.helpDrawer,
            item: AppDrawerItems.help,
          ),

          // View Source drawer item
          _buildItem(
            context,
            icon: Icons.flutter_dash_rounded,
            title: UIStrings.sourceCodeDrawer,
            item: AppDrawerItems.viewSource,
          ),

          // Rate App drawer item
          _buildItem(
            context,
            icon: Icons.stars_rounded,
            title: UIStrings.rateAppDrawer,
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
    Key? key,
    required this.color,
  }) : super(key: key);

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
          UIStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: ColorUtils.contrastOf(color),
              ),
        ),
      ),
    );
  }
}
