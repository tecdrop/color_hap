// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:typed_data';
import 'dart:ui';

/// Builds a color swatch image of the given [color] with the specified [width] and [height].
///
/// OPTIMIZE: Currently runs on UI thread but uses async encoding which yields to event loop.
/// For 512x512 solid colors this is fast. Move to `compute()` isolate only if image size increases
/// significantly (4K+) or profiling shows measurable jank.
Future<Uint8List> buildColorSwatch(Color color, int width, int height) async {
  // Create the color swatch using a sequence of graphical operations
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, .fromLTWH(0, 0, width.toDouble(), height.toDouble()));
  canvas.drawColor(color, .src);
  final picture = recorder.endRecording();

  // Convert the picture to a PNG image and return its bytes
  final img = await picture.toImage(width, height);
  final pngBytes = await img.toByteData(format: .png);
  if (pngBytes == null) {
    throw Exception('Failed to encode color swatch to PNG');
  }
  return pngBytes.buffer.asUint8List();
}
