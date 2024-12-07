import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/screens/search.dart';
import 'package:flutter/material.dart';
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
void main() {
  testWidgets('Displays search bar and handles input', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    expect(find.byType(TextField), findsOneWidget);
    
    await tester.enterText(find.byType(TextField), 'AAPL');
    expect(find.text('AAPL'), findsOneWidget);
  });
}
