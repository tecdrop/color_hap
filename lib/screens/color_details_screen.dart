// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/random_color.dart';

class ColorDetailsScreen extends StatelessWidget {
  const ColorDetailsScreen({
    super.key,
    required this.randomColor,
  });

  final RandomColor randomColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: randomColor.color,
        appBar: AppBar(
          title: Text(randomColor.title),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(icon: Icon(Icons.preview, color: Colors.black)),
              Tab(icon: Icon(Icons.info, color: Colors.black)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SizedBox.shrink(),
            Text('Info'),
          ],
        ),
      ),
    );
  }
}
