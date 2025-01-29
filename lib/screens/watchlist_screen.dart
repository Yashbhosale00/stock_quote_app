import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  final List<Map<String, dynamic>> watchlist;
  final Function(Map<String, dynamic>) removeFromWatchlist;

  const WatchlistScreen({
    Key? key,
    required this.watchlist,
    required this.removeFromWatchlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: watchlist.isEmpty
          ? const Center(
        child: Text(
          'No stocks in watchlist!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final stock = watchlist[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                stock['01. symbol'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text('Current Price: \$${stock['05. price']}'),
                  Text('Change: ${stock['09. change']}'),
                  Text('Change %: ${stock['10. change percent']}'),
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

  // Show confirmation dialog before removing a stock
  void _showConfirmationDialog(BuildContext context, Map<String, dynamic> stock) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Stock'),
          content: Text(
            'Are you sure you want to remove ${stock['01. symbol']} from your watchlist?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                removeFromWatchlist(stock); // Call the remove function
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}