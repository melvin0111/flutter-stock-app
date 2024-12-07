import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs442_mp6/models/fav_stock.dart';

void main() {
  testWidgets('Displays favorite stocks in Dashboard', (WidgetTester tester) async {
    final favoriteStockModel = FavoriteStockModel();
    // simulate adding a stock to the favoriteStockModel
    favoriteStockModel.addStock({'name': 'AAPL', 'price': '175.50', 'changePercent': '1.23%'});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => favoriteStockModel,
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    // checks if the AAPL stock is displayed
    expect(find.text('AAPL'), findsOneWidget);

  });

  testWidgets('Deletes a stock when the delete icon is tapped', (WidgetTester tester) async {
    final favoriteStockModel = FavoriteStockModel();
    favoriteStockModel.addStock({'name': 'AAPL', 'price': '175.50', 'changePercent': '1.23%'});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => favoriteStockModel,
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    expect(find.text('AAPL'), findsOneWidget);

    // tap the delete icon
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('AAPL'), findsNothing);
  });
  
}