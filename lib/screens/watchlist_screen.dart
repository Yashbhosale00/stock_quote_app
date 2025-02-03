import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Stock.dart';
import '../providers/stock_provider.dart';

class WatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: stockProvider.watchlist.isEmpty
          ? const Center(
        child: Text(
          'No stocks in watchlist!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: stockProvider.watchlist.length,
        itemBuilder: (context, index) {
          final stock = stockProvider.watchlist[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                stock.symbol,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text('Current Price: \$${stock.price}'),
                  Text('Change: ${stock.change}'),
                  Text('Change %: ${stock.changePercent}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  _showConfirmationDialog(context, stock);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, Stock stock) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Stock'),
          content: Text(
            'Are you sure you want to remove ${stock.symbol} from your watchlist?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<StockProvider>(context, listen: false).removeStock(stock);
                Navigator.of(context).pop();
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
