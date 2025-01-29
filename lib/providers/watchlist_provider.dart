import 'package:flutter/cupertino.dart';

class WatchlistProvider with ChangeNotifier{
  final List<String> _watchlist = [];
  List<String> get watchlist => _watchlist;

  void addStock(String stock){
    if(!_watchlist.contains(stock)){
      _watchlist.add(stock);
      notifyListeners();
    }
  }
  void removeStock(String stock){
    _watchlist.remove(stock);
    notifyListeners();
  }
}