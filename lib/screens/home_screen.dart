import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Services/api_service.dart';
import 'watchlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? stockData;
  List<Map<String, dynamic>> watchlist = [];
  bool isLoading = false;
  List<_ChartData> historicalData = [];


  final ApiService _apiService = ApiService();

  Future<void> fetchStockData(String symbol) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _apiService.fetchStockDetails(symbol);
      setState(() {
        stockData = data;
      });

      await fetchHistoricalData(symbol);
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

  Future<void> fetchHistoricalData(String symbol) async {
    try {
      final data = await _apiService.fetchHistoricalData(symbol);
      setState(() {
        historicalData = data.map((entry) {
          return _ChartData(
            DateTime.parse(entry["date"]),
            entry["close"],
          );
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading historical data: $e')),
      );
    }
  }


  void addToWatchlist(Map<String, dynamic> stock) {
    setState(() {
      if (!watchlist.any((element) => element['01. symbol'] == stock['01. symbol'])) {
        watchlist.add(stock);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock added to the watchlist successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock is already in the watchlist!')),
        );
      }
    });
  }


  void removeFromWatchlist(Map<String, dynamic> stock) {
    setState(() {
      watchlist.remove(stock);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => WatchlistScreen(
                      watchlist: watchlist,
                      removeFromWatchlist: removeFromWatchlist,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Watchlist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
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
                                'Symbol: ${stockData!['01. symbol']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text('Current Price: \$${stockData!['05. price']}'),
                              Text('Change: ${stockData!['09. change']}'),
                              Text('Change %: ${stockData!['10. change percent']}'),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  addToWatchlist(stockData!);
                                },
                                child: const Text('Add to Watchlist'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: historicalData.isEmpty
                            ? const Center(child: Text('No chart data available'))
                            : SfCartesianChart(
                          primaryXAxis: DateTimeAxis(),
                          series: <ChartSeries>[
                            LineSeries<_ChartData, DateTime>(
                              dataSource: historicalData,
                              xValueMapper: (_ChartData data, _) => data.date,
                              yValueMapper: (_ChartData data, _) => data.close,
                            ),
                          ],
                        ),
                      ),
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

class _ChartData {
  final DateTime date;
  final double close;

  _ChartData(this.date, this.close);
}