import 'dart:convert';
import 'package:http/http.dart' as http;

// API service is from Alpha Vantage, which provides me all the data for stocks and coins
class APIService {
  final String _apiKey = 'G4MT7YGAJ3ALH9LC'; 
  final String _baseUrl = 'https://www.alphavantage.co/query';

  // Grab the real time stocks prices
  Future<Map<String, dynamic>?> fetchStockPrice(String symbol) async {
    final uri = Uri.parse(
      '$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['Global Quote']; 
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      print('Error fetching stock price: $e');
      return null;
    }
  }

  // Grab the real time crypto prices
  Future<Map<String, dynamic>?> fetchCryptoPrice(String fromCurrency, String toCurrency) async {
    final uri = Uri.parse(
      '$_baseUrl?function=CURRENCY_EXCHANGE_RATE&from_currency=$fromCurrency&to_currency=$toCurrency&apikey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['Realtime Currency Exchange Rate'];
      } else {
        throw Exception('Failed to load cryptocurrency data');
      }
    } catch (e) {
      print('Error fetching cryptocurrency price: $e');
      return null;
    }
  }

  // Fetch historical stock price data
  Future<Map<String, dynamic>?> fetchHistoricalData(String symbol, String interval) async {
    final uri = Uri.parse(
      '$_baseUrl?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$interval&apikey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['Time Series ($interval)']; 
      } else {
        throw Exception('Failed to load historical data');
      }
    } catch (e) {
      print('Error fetching historical data: $e');
      return null;
    }
  }

  // Grab the top gainers
  // Had to manually add the symbols for the top gainers since there isn't nothing that would help me from there API, but had to limit to only ONE top gainer since there
  // API is limited to only 24 requests per day!!!!
Future<List<Map<String, String>>> fetchTopGainers() async {
  final List<String> symbols = ['AAPL']; // Example symbols
  final List<Map<String, String>> gainers = [];

  for (final symbol in symbols) {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey'),
      );

      print('Response for $symbol: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final quote = data['Global Quote'];

        if (quote != null) {
          final changePercent = quote['10. change percent']?.replaceAll('%', '') ?? '0.0';
          final price = quote['05. price'] ?? '0.00';

          gainers.add({
            'name': quote['01. symbol'] ?? symbol,
            'price': price,
            'changePercent': changePercent,
          });
        }
      }
    } catch (e) {
      print('Error fetching data for $symbol: $e');
    }
  }
  // Sort gainers by changePercent in descending order
    gainers.sort((a, b) => double.parse(b['changePercent'] ?? '0.0').compareTo(double.parse(a['changePercent'] ?? '0.0')));
    return gainers;
  }
}
