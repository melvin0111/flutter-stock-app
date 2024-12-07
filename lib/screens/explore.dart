import 'package:flutter/material.dart';
import '../service/api.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final APIService _apiService = APIService();
  List<Map<String, String>> _topGainers = []; 
  bool _isLoading = true;

  // Static fallback list for top gainers 
  final List<Map<String, String>> _fallbackTopGainers = [
    {'name': 'Tesla', 'symbol': 'TSLA', 'price': '890.75', 'changePercent': '2.30'},
    {'name': 'Apple', 'symbol': 'AAPL', 'price': '175.50', 'changePercent': '1.80'},
    {'name': 'Amazon', 'symbol': 'AMZN', 'price': '3450.60', 'changePercent': '1.60'},
    {'name': 'Google', 'symbol': 'GOOG', 'price': '2850.75', 'changePercent': '1.10'},
    {'name': 'NVIDIA', 'symbol': 'NVDA', 'price': '540.50', 'changePercent': '4.5'},
  ];

  // static list for popular stocks, honestly, I grabbed the most popular stocks in which I couldn't figure out a way to do this through the API, even if I did, loading up this page
  // would just take all of the requests so it's better to just have a static list of popular stocks
  final List<Map<String, String>> _popularStocks = [
    {'name': 'Apple', 'symbol': 'AAPL', 'price': '175.50'},
    {'name': 'Google', 'symbol': 'GOOG', 'price': '2850.75'},
    {'name': 'Amazon', 'symbol': 'AMZN', 'price': '3450.60'},
    {'name': 'Microsoft', 'symbol': 'MSFT', 'price': '330.20'},
    {'name': 'Tesla', 'symbol': 'TSLA', 'price': '890.75'},
    {'name': 'NVIDIA', 'symbol': 'NVDA', 'price': '540.50'},
    {'name': 'Meta', 'symbol': 'META', 'price': '310.25'},
    {'name': 'Netflix', 'symbol': 'NFLX', 'price': '390.40'},
    {'name': 'Adobe', 'symbol': 'ADBE', 'price': '680.15'},
    {'name': 'PayPal', 'symbol': 'PYPL', 'price': '210.80'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchTopGainers();
  }

  // In the _fetchTopGainers method, I have to call a specific top gainer since I was really limited and couldn't get the top gainers from the API but it stills grab accurate info from the API
  Future<void> _fetchTopGainers() async {
    try {
      final result = await _apiService.fetchTopGainers();

      if (result.isNotEmpty) {
        setState(() {
          _topGainers = result.map<Map<String, String>>((gainer) {
            return {
              'name': gainer['name'] ?? 'Unknown',
              'price': gainer['price'] ?? '0.00',
              'changePercent': gainer['changePercent'] ?? '0.0',
            };
          }).toList();
        });
      } else {
        _fallbackToStaticData();
      }
    } catch (e) {
      print('Error fetching top gainers: $e');
      _fallbackToStaticData();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fallbackToStaticData() {
    setState(() {
      _topGainers = _fallbackTopGainers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Stocks',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Gainers Section
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Top Gainers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _topGainers.isEmpty
                    ? const Center(child: Text('No data available'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: _topGainers.length,
                        itemBuilder: (context, index) {
                          final stock = _topGainers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: ListTile(
                              title: Text(
                                stock['name']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Price: \$${stock['price']}'),
                              trailing: Text(
                                '${stock['changePercent']}%',
                                style: TextStyle(
                                  color: double.parse(stock['changePercent']!) >=
                                          0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, {
                                  'name': stock['name']!,
                                  'price': stock['price']!,
                                  'changePercent': stock['changePercent']!,
                                });
                              },
                            ),
                          );
                        },
                      ),
            // Popular Stocks Section
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Popular Stocks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _popularStocks.length,
              itemBuilder: (context, index) {
                final stock = _popularStocks[index];
                return Card(
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      stock['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Price: \$${stock['price']}'),
                    onTap: () {
                      Navigator.pop(context, {
                        'name': stock['symbol']!,
                        'price': stock['price']!,
                        'changePercent': '0.0', 
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
