import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_hap/models/color_item.dart';
import 'package:color_hap/models/color_type.dart';
import 'package:color_hap/widgets/random_color_display.dart';

void main() {
  group('RandomColorDisplay', () {
    testWidgets('should display color name when available', (WidgetTester tester) async {
      // Arrange: ColorItem with name
      const colorItem = ColorItem(
        type: ColorType.basicColor,
        color: Color(0xFFFF0000),
        name: 'Red',
        listPosition: 0,
      );

      // Act: Build widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RandomColorDisplay(colorItem: colorItem),
          ),
        ),
      );

      // Assert: Should render 2 Text widgets (name + hex, no type shown in RandomColorDisplay)
      expect(find.byType(Text), findsNWidgets(2));
      // Name should be visible
      expect(find.text('Red'), findsOneWidget);
      // Hex should also be visible (always shown)
      expect(find.text('#FF0000'), findsOneWidget);
    });

    testWidgets('should display hex only when name is null', (WidgetTester tester) async {
      // Arrange: ColorItem without name (attractive/true color)
      const colorItem = ColorItem(
        type: ColorType.attractiveColor,
        color: Color(0xFFABCDEF),
        name: null,
        listPosition: 500,
      );

      // Act: Build widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RandomColorDisplay(colorItem: colorItem),
          ),
        ),
      );

      // Assert: Should render only 1 Text widget (hex only, no name or type)
      expect(find.byType(Text), findsOneWidget);
      // Hex should be visible
      expect(find.text('#ABCDEF'), findsOneWidget);
    });

    testWidgets('should use white text on dark colors', (WidgetTester tester) async {
      // Arrange: Dark color (black)
      const colorItem = ColorItem(
        type: ColorType.basicColor,
        color: Color(0xFF000000),
        name: 'Black',
        listPosition: 0,
      );

      // Act: Build widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RandomColorDisplay(colorItem: colorItem),
          ),
        ),
      );

      // Assert: Find all Text widgets and verify they use white color
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final text in textWidgets) {
        expect(text.style?.color, equals(Colors.white));
      }
    });

    testWidgets('should use black text on light colors', (WidgetTester tester) async {
      // Arrange: Light color (white)
      const colorItem = ColorItem(
        type: ColorType.basicColor,
        color: Color(0xFFFFFFFF),
        name: 'White',
        listPosition: 1,
      );

      // Act: Build widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RandomColorDisplay(colorItem: colorItem),
          ),
        ),
      );

      // Assert: Find all Text widgets and verify they use black color
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final text in textWidgets) {
        expect(text.style?.color, equals(Colors.black));
      }
    });

    testWidgets('should call onDoubleTap when double-tapped', (WidgetTester tester) async {
      // Arrange: ColorItem with callback
      const colorItem = ColorItem(
        type: ColorType.basicColor,
        color: Color(0xFFFF0000),
        name: 'Red',
        listPosition: 0,
      );
      var doubleTapCalled = false;

      // Act: Build widget with callback
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RandomColorDisplay(
              colorItem: colorItem,
              onDoubleTap: () {
                doubleTapCalled = true;
              },
            ),
          ),
        ),
      );

      // Act: Perform double tap gesture (tap twice quickly)
      final gesture = await tester.startGesture(tester.getCenter(find.byType(GestureDetector)));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 50)); // Short delay between taps
      await gesture.down(tester.getCenter(find.byType(GestureDetector)));
      await gesture.up();
      await tester.pumpAndSettle();

      // Assert: Callback should be called
      expect(doubleTapCalled, isTrue);
    });

    testWidgets('should call onLongPress when long-pressed', (WidgetTester tester) async {
      // Arrange: ColorItem with callback
      const colorItem = ColorItem(
        type: ColorType.basicColor,
        color: Color(0xFFFF0000),
        name: 'Red',
        listPosition: 0,
      );
      var longPressCalled = false;

      // Act: Build widget with callback
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RandomColorDisplay(
              colorItem: colorItem,
              onLongPress: () {
                longPressCalled = true;
              },
            ),
          ),
        ),
      );

      // Act: Long press the widget
      await tester.longPress(find.byType(GestureDetector));

      // Assert: Callback should be called
      expect(longPressCalled, isTrue);
    });
  });
}
