import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_quote_app/providers/stock_provider.dart';
import 'package:stock_quote_app/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
      ],
      child: const StockQuoteApp(),
    ),
  );
}

class StockQuoteApp extends StatelessWidget {
  const StockQuoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Quote App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
