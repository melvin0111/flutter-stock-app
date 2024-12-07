import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cs442_mp6/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Favorites and Notes Integration Test', (WidgetTester tester) async {
    app.main(); //starts app
    await tester.pumpAndSettle();

    // go to search page
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField); // search AAPL stock
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'AAPL');
    await tester.pumpAndSettle();

    final addButton = find.byIcon(Icons.star_border); // add AAPL stock to favorites
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('AAPL'), findsOneWidget); // AAPL stock is in the dashboard

    final addNoteButton = find.byIcon(Icons.add); // add note to AAPL stock
    expect(addNoteButton, findsWidgets); 

    await tester.tap(addNoteButton.first);
    await tester.pumpAndSettle();

    final noteField = find.byType(TextField);
    expect(noteField, findsOneWidget);

    await tester.enterText(noteField, 'Test note, when is the iphone 20 coming out?');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    expect(find.text('Test note, when is the iphone 20 coming out?'), findsOneWidget); // find note in journal
  });
}
