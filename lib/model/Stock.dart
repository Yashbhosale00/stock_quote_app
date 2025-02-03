class Stock {
  final String symbol;
  final double price;
  final double change;
  final double changePercent;

  Stock({
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      symbol: map['01. symbol'] ?? '',
      price: double.tryParse(map['05. price'].toString()) ?? 0.0,
      change: double.tryParse(map['09. change'].toString()) ?? 0.0,
      changePercent: double.tryParse(map['10. change percent'].toString()) ?? 0.0,
    );
  }
}
