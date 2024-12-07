import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard.dart';
import 'screens/search.dart';
import 'screens/explore.dart';
import 'screens/test.dart';
import 'models/fav_stock.dart';

void main() {
  runApp(const StockTrackerApp());
}

class StockTrackerApp extends StatelessWidget {
  const StockTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoriteStockModel(),
      child: MaterialApp(
        title: 'Stock Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const DashboardScreen(),
          '/search': (context) => const SearchScreen(),
          '/explore': (context) => const ExploreScreen(),
          '/test': (context) => const TestScreen(), // Decided to keep test screen as the Note screen(saved me time)
        },
      ),
    );
  }
}
