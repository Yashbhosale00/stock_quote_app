import 'package:flutter/cupertino.dart';
import '../model/Stock.dart';

class StockProvider with ChangeNotifier {
  final List<Stock> _watchlist = [];

  List<Stock> get watchlist => _watchlist;

  void addStock(Stock stock) {
    if (!_watchlist.any((element) => element.symbol == stock.symbol)) {
      _watchlist.add(stock);
      notifyListeners();
    }
  }

  void removeStock(Stock stock) {
    _watchlist.remove(stock);
    notifyListeners();
  }
}
