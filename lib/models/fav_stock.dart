import 'package:flutter/foundation.dart';

class FavoriteStockModel extends ChangeNotifier {
  final List<Map<String, String>> _stocks = [];
  

  List<Map<String, String>> get stocks => _stocks;

  void addStock(Map<String, String> stock) {
    if (!_stocks.any((s) => s['name'] == stock['name'])) { // Check if the stock is already in the list
      _stocks.add(stock);
      notifyListeners();
    }
  }

  void removeStock(String stockName) {
    _stocks.removeWhere((stock) => stock['name'] == stockName);
    notifyListeners();
  }

  void clearStocks() {
    _stocks.clear();
    notifyListeners();
  }
  void updateStock(String stockName, Map<String, String> updatedStock) {
  final index = _stocks.indexWhere((stock) => stock['name'] == stockName);

  if (index != -1) {
    _stocks[index] = updatedStock;
    notifyListeners();
    }
  }
}
