import 'package:flutter/material.dart';
import '../service/api.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final APIService _apiService = APIService();
  final TextEditingController _searchController = TextEditingController();
  Map<String, String>? _searchResult;
  bool _isLoading = false;
  String _errorMessage = '';

  // Static backup list of stocks/coins because I RAN OUT OF API CALLS, I only have 25 a day(so unfair :( ) 
final List<Map<String, String>> _backupStocks = [
  {'name': 'Apple', 'symbol': 'AAPL', 'price': '175.50', 'changePercent': '0.5'},
  {'name': 'Tesla', 'symbol': 'TSLA', 'price': '890.75', 'changePercent': '2.3'},
  {'name': 'Google', 'symbol': 'GOOG', 'price': '2850.75', 'changePercent': '1.1'},
  {'name': 'Amazon', 'symbol': 'AMZN', 'price': '3450.60', 'changePercent': '1.6'},
  {'name': 'Bitcoin', 'symbol': 'BTC', 'price': '51000.00', 'changePercent': '5.0'},
  {'name': 'Ethereum', 'symbol': 'ETH', 'price': '3400.00', 'changePercent': '3.2'},
  {'name': 'Meta', 'symbol': 'META', 'price': '310.25', 'changePercent': '1.0'},
  {'name': 'Netflix', 'symbol': 'NFLX', 'price': '390.40', 'changePercent': '2.4'},
  {'name': 'NVIDIA', 'symbol': 'NVDA', 'price': '540.50', 'changePercent': '4.5'},
  {'name': 'Adobe', 'symbol': 'ADBE', 'price': '680.15', 'changePercent': '0.7'},
  {'name': 'PayPal', 'symbol': 'PYPL', 'price': '210.80', 'changePercent': '-0.3'},
  {'name': 'Microsoft', 'symbol': 'MSFT', 'price': '330.20', 'changePercent': '0.8'},
  {'name': 'Visa', 'symbol': 'V', 'price': '232.10', 'changePercent': '1.2'},
  {'name': 'Mastercard', 'symbol': 'MA', 'price': '345.60', 'changePercent': '0.9'},
  {'name': 'Alibaba', 'symbol': 'BABA', 'price': '95.50', 'changePercent': '-0.6'},
  {'name': 'Salesforce', 'symbol': 'CRM', 'price': '200.75', 'changePercent': '1.7'},
  {'name': 'Intel', 'symbol': 'INTC', 'price': '56.30', 'changePercent': '0.4'},
  {'name': 'AMD', 'symbol': 'AMD', 'price': '150.50', 'changePercent': '2.2'},
  {'name': 'Zoom', 'symbol': 'ZM', 'price': '100.25', 'changePercent': '3.3'},
  {'name': 'Spotify', 'symbol': 'SPOT', 'price': '120.75', 'changePercent': '0.6'},
  {'name': 'Coca-Cola', 'symbol': 'KO', 'price': '55.50', 'changePercent': '0.2'},
  {'name': 'PepsiCo', 'symbol': 'PEP', 'price': '158.75', 'changePercent': '1.0'},
  {'name': 'Walmart', 'symbol': 'WMT', 'price': '144.50', 'changePercent': '0.8'},
  {'name': 'Target', 'symbol': 'TGT', 'price': '220.25', 'changePercent': '-1.1'},
  {'name': 'Ford', 'symbol': 'F', 'price': '12.50', 'changePercent': '1.2'},
  {'name': 'GM', 'symbol': 'GM', 'price': '32.40', 'changePercent': '0.7'},
  {'name': 'Exxon Mobil', 'symbol': 'XOM', 'price': '102.50', 'changePercent': '-0.3'},
  {'name': 'Chevron', 'symbol': 'CVX', 'price': '115.75', 'changePercent': '0.9'},
  {'name': 'Disney', 'symbol': 'DIS', 'price': '98.50', 'changePercent': '-0.8'},
  {'name': 'Uber', 'symbol': 'UBER', 'price': '44.30', 'changePercent': '1.5'},
  {'name': 'Lyft', 'symbol': 'LYFT', 'price': '12.75', 'changePercent': '0.3'},
  {'name': 'Shopify', 'symbol': 'SHOP', 'price': '45.80', 'changePercent': '2.5'},
  {'name': 'Snapchat', 'symbol': 'SNAP', 'price': '10.50', 'changePercent': '-1.4'},
  {'name': 'Block', 'symbol': 'SQ', 'price': '75.60', 'changePercent': '1.8'},
  {'name': 'AT&T', 'symbol': 'T', 'price': '14.50', 'changePercent': '0.6'},
  {'name': 'Verizon', 'symbol': 'VZ', 'price': '33.20', 'changePercent': '0.5'},
  {'name': 'Starbucks', 'symbol': 'SBUX', 'price': '100.50', 'changePercent': '-0.7'},
  {'name': 'McDonald\'s', 'symbol': 'MCD', 'price': '287.75', 'changePercent': '0.9'},
  {'name': 'Domino\'s', 'symbol': 'DPZ', 'price': '389.50', 'changePercent': '1.4'},
  {'name': 'Goldman Sachs', 'symbol': 'GS', 'price': '340.25', 'changePercent': '2.0'},
  {'name': 'JPMorgan', 'symbol': 'JPM', 'price': '150.75', 'changePercent': '1.1'},
  {'name': 'Berkshire Hathaway', 'symbol': 'BRK.A', 'price': '509000.00', 'changePercent': '0.8'},
  {'name': 'Coinbase', 'symbol': 'COIN', 'price': '85.25', 'changePercent': '-1.2'},
  {'name': 'Rivian', 'symbol': 'RIVN', 'price': '16.50', 'changePercent': '1.7'},
  {'name': 'Lucid', 'symbol': 'LCID', 'price': '8.50', 'changePercent': '-0.9'},
  {'name': 'GameStop', 'symbol': 'GME', 'price': '18.75', 'changePercent': '0.3'},
  {'name': 'AMC Entertainment', 'symbol': 'AMC', 'price': '5.75', 'changePercent': '-2.1'},
  {'name': 'Ethereum Classic', 'symbol': 'ETC', 'price': '50.00', 'changePercent': '2.5'},
  {'name': 'Litecoin', 'symbol': 'LTC', 'price': '200.50', 'changePercent': '4.0'},
  {'name': 'Dogecoin', 'symbol': 'DOGE', 'price': '0.25', 'changePercent': '6.3'},
  {'name': 'Cardano', 'symbol': 'ADA', 'price': '1.30', 'changePercent': '2.7'},
  {'name': 'Solana', 'symbol': 'SOL', 'price': '130.50', 'changePercent': '3.5'},
  {'name': 'Polkadot', 'symbol': 'DOT', 'price': '40.50', 'changePercent': '2.1'},
  {'name': 'Binance Coin', 'symbol': 'BNB', 'price': '600.00', 'changePercent': '3.9'},
  {'name': 'XRP', 'symbol': 'XRP', 'price': '0.85', 'changePercent': '5.6'},
  {'name': 'Shiba Inu', 'symbol': 'SHIB', 'price': '0.000045', 'changePercent': '10.5'},
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Stocks',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // the search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter stock symbol (e.g., AAPL)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) => _searchStock(value),
            ),
          ),

          // loading spinner
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          // error message
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

          // search result based off the API
          if (_searchResult != null && !_isLoading)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: ListTile(
                title: Text(
                  _searchResult!['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Price: \$${_searchResult!['price']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () {
                    Navigator.pop(context, _searchResult);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _searchStock(String symbol) async {
    if (symbol.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a stock symbol';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _searchResult = null;
    });

    try {
      // attempts API call first
      final result = await _apiService.fetchStockPrice(symbol);
      if (result != null) {
        setState(() {
          _searchResult = {
            'name': result['01. symbol'] ?? 'Unknown',
            'price': result['05. price'] ?? '0.00',
            'changePercent': result['10. change percent'] ?? '0.0',
          };
        });
      } else {
        // the  fallback to static list if API returns null
        _fallbackToStaticList(symbol);
      }
    } catch (e) {
      _fallbackToStaticList(symbol);
    }

    setState(() {
      _isLoading = false;
    });
  }

 // searches the static list of stocks/coins
  void _fallbackToStaticList(String symbol) {
    final fallbackResult = _backupStocks.firstWhere(
      (stock) => stock['symbol']!.toLowerCase() == symbol.toLowerCase(),
      orElse: () => {},
    );

    if (fallbackResult.isNotEmpty) {
      setState(() {
        _searchResult = {
          'name': fallbackResult['name']!,
          'price': fallbackResult['price']!,
          'changePercent': fallbackResult['changePercent']!,
        };
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'No results found for "$symbol"';
      });
    }
  }
}
