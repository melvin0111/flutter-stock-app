import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fav_stock.dart';
import '../service/api.dart';
import '../service/db_helper.dart';
import '../models/journel_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // apiService and dbHelper instances
  final APIService _apiService = APIService(); 
  final DBHelper _dbHelper = DBHelper(); 
  bool _isRefreshing = false; // refresh status
  bool _sortAlphabetically = true; // sort order based off alphabet (but also has option for most recent)
  @override
  Widget build(BuildContext context) {
    final favoriteStocks = context.watch<FavoriteStockModel>().stocks;

    // Sort stocks/crypto based on two options: alphabetically or recently added
    final sortedStocks = [...favoriteStocks];
    if (_sortAlphabetically) {
      sortedStocks.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    } else {
      sortedStocks.sort((a, b) => favoriteStocks.indexOf(b) - favoriteStocks.indexOf(a)); 
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            _isRefreshing ? Icons.sync : Icons.refresh,
            color: Colors.blue,
          ),
          onPressed: _refreshFavorites,
          tooltip: 'Refresh Prices',
        ),
        actions: [
          IconButton(
            icon: Icon(
              _sortAlphabetically ? Icons.abc : Icons.access_time,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _sortAlphabetically = !_sortAlphabetically; // toggle
              });
            },
            tooltip: _sortAlphabetically ? 'Sort by Recently Added' : 'Sort Alphabetically',
          ),
        ],
      ),
      body: sortedStocks.isEmpty
          ? const Center(
              child: Text(
                'No favorite stocks yet, add from the Search! Also, Add notes to your favorite stocks!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: sortedStocks.length,
              itemBuilder: (context, index) {
                final stock = sortedStocks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      stock['name'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Price: \$${stock['price'] ?? '0.00'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Note icon
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () => _showAddNoteDialog(stock['name']!),
                        ),
                        const SizedBox(width: 8.0),
                        // Delete icon
                        GestureDetector(
                          onTap: () {
                            context.read<FavoriteStockModel>().removeStock(stock['name']!);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Bottom Navigation Bar (dashboard, search, explore, journnal)
          bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, color: Colors.blue),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.blue),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore, color: Colors.blue),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_add, color: Colors.blue),
              label: 'Notes',
            ),
          ],
          currentIndex: 0, // Dashboard index 0
          onTap: (index) async {
            if (index == 1) { // Search index 1
              final result = await Navigator.pushNamed(context, '/search');
              if (result != null && result is Map<String, String>) {
                context.read<FavoriteStockModel>().addStock(result); // Add stock to favorites
              }
            } else if (index == 2) { // Explore index 2
              Navigator.pushNamed(context, '/explore');
            } else if (index == 3) { // Journal index 3
              Navigator.pushNamed(context, '/test');
            }
          },
        ),
      );
    }

// Refresh favorite stocks prices
  Future<void> _refreshFavorites() async {
    final favoriteStocks = context.read<FavoriteStockModel>().stocks;

    setState(() {
      _isRefreshing = true;
    });

    try {
      for (int i = 0; i < favoriteStocks.length; i++) {
        final stock = favoriteStocks[i];
        final result = await _apiService.fetchStockPrice(stock['name']!);

        if (result != null) {
          context.read<FavoriteStockModel>().updateStock(
                stock['name']!,
                {
                  'name': result['01. symbol'] ?? stock['name']!,
                  'price': result['05. price'] ?? stock['price']!,
                  'changePercent': result['10. change percent']?.replaceAll('%', '') ??
                      stock['changePercent']!,
                },
              );
        }
      }
    } catch (e) {
      print('Error refreshing prices: $e');
    }

    setState(() {
      _isRefreshing = false;
    });
  }
// Show dialog to add note for a stock
  void _showAddNoteDialog(String stockName) {
    final TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note for $stockName'),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'Enter your note here...',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
              style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () async {
                final note = _noteController.text.trim();
                if (note.isNotEmpty) {
                  final timestamp = DateTime.now().toIso8601String();
                  final entry = JournalEntry(
                    stockName: stockName,
                    notes: note,
                    timestamp: timestamp,
                  );
                  await _dbHelper.insert(entry.toMap()); // Insert note to database
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Note added for $stockName!')),
                  );
                }
              },
              child: const Text('Save',
              style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }
}


