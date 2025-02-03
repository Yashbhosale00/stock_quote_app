import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_quote_app/screens/watchlist_screen.dart';
import '../Services/api_service.dart';
import '../model/Stock.dart';
import '../providers/stock_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Stock? stockData;
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  Future<void> fetchStockData(String symbol) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _apiService.fetchStockDetails(symbol);
      setState(() {
        stockData = Stock.fromMap(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addToWatchlist(Stock stock) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock added to the watchlist successfully!')),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    var watchlistProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter Stock Symbol',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final symbol = _searchController.text.trim().toUpperCase();
                if (symbol.isNotEmpty) {
                  fetchStockData(symbol);
                }
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchlistScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Watchlist'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (stockData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Symbol: ${stockData!.symbol}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text('Current Price: \$${stockData!.price}'),
                              Text('Change: ${stockData!.change}'),
                              Text('Change %: ${stockData!.changePercent}'),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  watchlistProvider.addStock(stockData!);
                                  addToWatchlist(stockData!);
                                },
                                child: const Text('Add to Watchlist'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: Text('Search for a stock to see its details!'),
              ),
          ],
        ),
      ),
    );
  }
}
