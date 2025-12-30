// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// A very simple widget that displays a long app bar title in two rows on small screens.
class LongAppBarTitle extends StatelessWidget {
  const LongAppBarTitle({
    super.key,
    required this.row1,
    required this.row2,
  });

  /// The text to display in the first row, with a smaller font size.
  final String row1;

  /// The text to display in the second row, with the standard app bar title font size.
  final String row2;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // The layout for small screens
    final Widget smallScreenLayout = Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: <Widget>[
        // The first row with a smaller font size
        Text(
          row1,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.0),
        ),

        // The second row inherits the standard app bar title style
        Text(row2),
      ],
    );

    return isSmallScreen ? smallScreenLayout : Text('$row1 $row2');
  }
}
