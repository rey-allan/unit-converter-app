import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/widgets/category.dart';

void main() {
  testWidgets('Widget has icon, color and text', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
            home: Material(
              child: Category(
                  icon: Icons.computer,
                  color: Colors.blueAccent,
                  text: 'Degrees',
                  onTapHandler: () => print('I was tapped!'),
              ),
            ),
        )
    );

    expect(find.byIcon(Icons.computer), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);

    final Text text = tester.widget(find.byType(Text));
    expect(text.data, equals('Degrees'));

    final InkWell inkWell = tester.widget(find.byType(InkWell));
    expect(inkWell.splashColor, equals(Colors.blueAccent));
    expect(inkWell.highlightColor, equals(Colors.blueAccent));
  });

  testWidgets('Handler is called when tapped', (WidgetTester tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
        MaterialApp(
            home: Material(
                child: Category(
                  icon: Icons.computer,
                  color: Colors.blueAccent,
                  text: 'Degrees',
                  onTapHandler: () => wasTapped = !wasTapped,
                ),
            ),
        )
    );

    expect(wasTapped, isFalse);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(wasTapped, isTrue);
  });
}
