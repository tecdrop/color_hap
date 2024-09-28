// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

/// A very simple widget that displays a long app bar title in two rows.
///
/// Can be used to display a longer app bar title in two rows.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          row1,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          row2,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ],
    );
  }
}
