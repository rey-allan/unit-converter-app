import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/screens/category_screen.dart';
import 'package:unit_converter/screens/converter_screen.dart';
import 'package:unit_converter/widgets/backdrop.dart';

// The [CategoryScreen] needs to be wrapped inside a [MediaQuery] element
// in order to control the window size to effectively set the orientation to
// portrait since by default, it always starts as landscape. There is also no
// better way to control the orientation of the device programmatically.
// See: https://github.com/flutter/flutter/issues/10307
// See: https://github.com/flutter/flutter/issues/6380
// See: https://github.com/flutter/flutter/issues/6381
// See: https://github.com/flutter/flutter/issues/12994
// See: https://tinyurl.com/y7gfl2yl

void main() {
  final MediaQueryData _portrait = MediaQueryData
      .fromWindow(ui.window)
      .copyWith(size: Size(1200.0, 1980.0));

  // The only difference between portrait and landscape mode is that in
  // landscape mode the width (1980.) is larger than the height (1200.0)
  final MediaQueryData _landscape = MediaQueryData
      .fromWindow(ui.window)
      .copyWith(size: Size(1980.0, 1200.0));

  setUp(() {
    // Also the initial size of the device needs to be setup!
    // See: https://github.com/flutter/flutter/issues/12994#issuecomment-397321431
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration(
        size: const Size(1200.0, 1980.0)
    );
  });

  testWidgets('Screen displays a Backdrop', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: _portrait,
          // We need to wrap the [Widget] using a [DefaultAssetBundle] to be
          // able to inject our test bundle
          child: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: CategoryScreen(),
          ),
        )
      )
    );

    // Wait for all async assets to be loaded
    await tester.pumpAndSettle();

    expect(find.byType(Backdrop), findsOneWidget);
  });

  testWidgets('Unit Converter for Length is displayed by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: _portrait,
            child: DefaultAssetBundle(
              bundle: TestAssetBundle(),
              child: CategoryScreen(),
            ),
          ),
        )
    );

    // Wait for all async assets to be loaded
    await tester.pumpAndSettle();

    expect(find.byType(ConverterScreen), findsOneWidget);
    // It should find two widgets with text 'Length': the category in the menu,
    // and the title of the current unit converter screen
    expect(find.text('Length'), findsNWidgets(2));
  });

  testWidgets('Unit Converter is changed when a category is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: _portrait,
            child: DefaultAssetBundle(
              bundle: TestAssetBundle(),
              child: CategoryScreen(),
            ),
          ),
        )
    );

    // Wait for all async assets to be loaded
    await tester.pumpAndSettle();

    // Initially only one widget should exist in the category list
    expect(find.text('Time'), findsOneWidget);

    // First, close the current unit converter screen by tapping the close menu
    await tester.tap(find.byType(IconButton));
    // Wait for all animations to finish
    await tester.pumpAndSettle();

    // Now, tap the 'Time' category and wait for all animations to finish
    await tester.tap(find.text('Time'));
    await tester.pumpAndSettle();

    expect(find.byType(ConverterScreen), findsOneWidget);
    // Now, it should find two widgets with text 'Time': the category in the
    // menu, and the title of the new unit converter screen
    expect(find.text('Time'), findsNWidgets(2));
  });

  testWidgets('Categories are displayed as a list in portrait mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: _portrait,
          child: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: CategoryScreen(),
          ),
        ),
      )
    );

    // Wait for all async assets to be loaded
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Categories are displayed as a grid in landscape mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: _landscape,
          child: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: CategoryScreen(),
          ),
        ),
      )
    );

    // Wait for all async assets to be loaded
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
  });
}

/// A test class used to inject the assets bundle from where the units are
/// loaded because the real assets are not available for unit tests.
/// See: https://docs.flutter.io/flutter/widgets/DefaultAssetBundle-class.html
class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, { bool cache: true }) async {
    if (key == 'assets/data/units.json') {
      return """
        {
          "Length": [{"name": "Unit 1", "conversion": 1.0}],
          "Time": [{"name": "Unit 1", "conversion": 1.0}]
        }
      """;
    }

    return null;
  }

  @override
  Future<ByteData> load(String key) async {
    return new ByteData.view(new Uint8List.fromList(
        new File('assets/icons/test_icon.png').readAsBytesSync()).buffer);
  }
}
