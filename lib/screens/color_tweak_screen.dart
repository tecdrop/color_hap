// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/strings.dart' as strings;
import '../models/color_item.dart';
import '../services/color_lookup_service.dart' as color_lookup;
import '../utils/color_utils.dart' as color_utils;
import '../widgets/color_shades_list.dart';
import '../widgets/rgb_sliders.dart';

/// A screen for tweaking colors with RGB sliders and shade selection.
///
/// Provides two tabs:
/// - Adjust: RGB sliders for precise color adjustment
/// - Shades: A list of color shades for quick selection
class ColorTweakScreen extends StatefulWidget {
  const ColorTweakScreen({
    super.key,
    required this.initialColor,
  });

  /// The initial color to display and edit.
  final Color initialColor;

  @override
  State<ColorTweakScreen> createState() => _ColorTweakScreenState();
}

class _ColorTweakScreenState extends State<ColorTweakScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentColor = widget.initialColor;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onColorChanged(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  void _onShadeSelected(Color color) {
    setState(() {
      _currentColor = color;
      _tabController.animateTo(0); // Switch to Adjust tab
    });
  }

  Future<void> _pasteColor() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      final color = color_utils.rgbHexToColor(clipboardData!.text);
      if (color != null) {
        setState(() {
          _currentColor = color;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid color code in clipboard')),
          );
        }
      }
    }
  }

  void _applyColor() {
    // Create ColorItem from current color using lookup service
    final knownColor = color_lookup.findKnownColor(_currentColor);
    final colorItem = knownColor ??
        ColorItem(
          type: .trueColor,
          color: _currentColor,
          listPosition: color_utils.toRGB24(_currentColor),
        );

    Navigator.of(context).pop<ColorItem>(colorItem);
  }

  @override
  Widget build(BuildContext context) {
    final contrastColor = color_utils.contrastColor(_currentColor);

    return Scaffold(
      backgroundColor: _currentColor,
      appBar: AppBar(
        backgroundColor: _currentColor,
        foregroundColor: contrastColor,
        iconTheme: IconThemeData(color: contrastColor),
        title: Text('Tweak Color', style: TextStyle(color: contrastColor)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: contrastColor,
          unselectedLabelColor: contrastColor.withValues(alpha: 0.6),
          indicatorColor: contrastColor,
          tabs: const [
            Tab(text: 'Adjust'),
            Tab(text: 'Shades'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_paste),
            tooltip: 'Paste color',
            onPressed: _pasteColor,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Apply',
            onPressed: _applyColor,
          ),
        ],
      ),
      body: Column(
        children: [
          // Known color indicator
          _buildKnownColorIndicator(contrastColor),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Adjust tab
                SingleChildScrollView(
                  child: RgbSliders(
                    color: _currentColor,
                    onColorChanged: _onColorChanged,
                    contrastColor: contrastColor,
                  ),
                ),

                // Shades tab
                ColorShadesList(
                  baseColor: _currentColor,
                  onShadeSelected: _onShadeSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnownColorIndicator(Color contrastColor) {
    final knownColor = color_lookup.findKnownColor(_currentColor);
    final hexCode = color_utils.toHexString(_currentColor);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          if (knownColor != null) ...[
            Chip(
              label: Text(
                strings.colorTypeSingular[knownColor.type]!,
                style: TextStyle(
                  color: contrastColor,
                  fontSize: 12.0,
                ),
              ),
              backgroundColor: contrastColor.withValues(alpha: 0.2),
              side: BorderSide(color: contrastColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(width: 8.0),
            Text(
              knownColor.name!,
              style: TextStyle(
                color: contrastColor,
                fontSize: 16.0,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(width: 8.0),
          ],
          Text(
            hexCode,
            style: TextStyle(
              color: contrastColor,
              fontSize: 16.0,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
