// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// A widget that draws a checkerboard grid to indicate transparency.
class TransparencyGrid extends StatelessWidget {
  const TransparencyGrid({
    super.key,
    this.light = const Color(0xFFFFFFFF),
    this.dark = const Color(0xFFDCDCDC),
    this.squareSize = 8.0,
    this.offset = .zero,
    this.child,
  });

  /// The color of the light squares.
  ///
  /// Defaults to white.
  final Color light;

  /// The color of the dark squares.
  ///
  /// Defaults to Gainsboro (#DCDCDC).
  final Color dark;

  /// The size of each square in the grid.
  ///
  /// The default value is 8.0 pixels.
  final double squareSize;

  /// The offset of the grid.
  ///
  /// Defaults to [Offset.zero].
  final Offset offset;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TransparencyGridPainter(
        light: light,
        dark: dark,
        squareSize: squareSize,
        offset: offset,
      ),
      child: child,
    );
  }
}

/// A painter that draws the checkered pattern of a transparency grid.
///
/// Based on [CheckeredPainter](https://github.com/deckerst/aves/blob/develop/lib/widgets/common/fx/checkered_decoration.dart).
class _TransparencyGridPainter extends CustomPainter {
  _TransparencyGridPainter({
    required Color light,
    required Color dark,
    required this.squareSize,
    required this.offset,
  }) : lightPaint = Paint()..color = light,
       darkPaint = Paint()..color = dark;

  /// The style to use when drawing the light squares.
  ///
  /// Uses the light color passed to the constructor.
  final Paint lightPaint;

  /// The style to use when drawing the dark squares.
  ///
  /// Uses the dark color passed to the constructor.
  final Paint darkPaint;

  /// The size of each square in the grid.
  final double squareSize;

  /// The offset of the grid.
  final Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background in the light color.
    final background = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(background, lightPaint);

    // Apply the offset.
    final dx = offset.dx % (squareSize * 2);
    final dy = offset.dy % (squareSize * 2);

    // Calculate the number of squares in each direction.
    final xMax = (size.width / squareSize).ceil();
    final yMax = (size.height / squareSize).ceil();

    // Draw the grid squares.
    for (var x = -2; x < xMax; x++) {
      for (var y = -2; y < yMax; y++) {
        if ((x + y) % 2 == 0) {
          final square = Rect.fromLTWH(
            dx + x * squareSize,
            dy + y * squareSize,
            squareSize,
            squareSize,
          );
          if (square.overlaps(background)) {
            canvas.drawRect(square.intersect(background), darkPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_TransparencyGridPainter oldPainter) {
    return oldPainter.lightPaint != lightPaint ||
        oldPainter.darkPaint != darkPaint ||
        oldPainter.squareSize != squareSize ||
        oldPainter.offset != offset;
  }

  @override
  bool hitTest(Offset position) => false;
}
