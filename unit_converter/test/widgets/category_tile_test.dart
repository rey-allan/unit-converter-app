import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/model/category.dart';
import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/widgets/category_tile.dart';

void main() {
  final List<Unit> units = <Unit>[
    Unit(name: 'Unit 1', conversion: 1.0),
    Unit(name: 'Unit 2', conversion: 2.0),
    Unit(name: 'Unit 3', conversion: 3.0),
  ];

  testWidgets('Widget has icon, color and text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: CategoryTile(
          category: Category(
            iconLocation: 'assets/icon/length.png',
            color: ColorSwatch(Colors.blueAccent.value, {
              'highlight': Colors.blueAccent,
              'splash': Colors.blue,
            }),
            name: 'Degrees',
            units: units,
          ),
          onTapHandler: (value) => print('I was tapped!'),
        ),
      ),
    ));

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);

    final Text text = tester.widget(find.byType(Text));
    expect(text.data, equals('Degrees'));

    final InkWell inkWell = tester.widget(find.byType(InkWell));
    expect(inkWell.splashColor, equals(Colors.blue));
    expect(inkWell.highlightColor, equals(Colors.blueAccent));
  });

  testWidgets('Handler is called when tapped', (WidgetTester tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: CategoryTile(
          category: Category(
            iconLocation: 'assets/icon/length.png',
            color: ColorSwatch(Colors.blueAccent.value, {
              'highlight': Colors.blueAccent,
              'splash': Colors.blue,
            }),
            name: 'Degrees',
            units: units,
          ),
          onTapHandler: (value) => wasTapped = !wasTapped,
        ),
      ),
    ));

    expect(wasTapped, isFalse);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(wasTapped, isTrue);
  });

  testWidgets('Handler passes back Category when tapped',
      (WidgetTester tester) async {
    final Category expectedCategory = Category(
      name: 'Degrees',
      units: units,
      iconLocation: 'assets/icon/length.png',
      color: ColorSwatch(Colors.blueAccent.value, {
        'highlight': Colors.blueAccent,
        'splash': Colors.blue,
      }),
    );
    
    Category receivedCategory;
    
    await tester.pumpWidget(MaterialApp(
        home: Material(
            child: CategoryTile(
              category: expectedCategory,
              onTapHandler: (category) => receivedCategory = category,
            )
        )
    ));
    
    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(receivedCategory, equals(expectedCategory));
  });
}
