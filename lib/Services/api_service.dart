import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://www.alphavantage.co/';
  final String _apiKey = 'FFIYJY8OJ4A27HZL';

  Future<Map<String, dynamic>> fetchStockDetails(String symbol) async {
    final url = Uri.parse('$_baseUrl/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('Global Quote')) {
        return data['Global Quote'];
      } else {
        throw Exception('Stock data not found');
      }
    } else {
      throw Exception('Failed to fetch stock data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchHistoricalData(String symbol) async {
    final url = Uri.parse('$_baseUrl/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timeSeries = data['Time Series (Daily)'];

        if (timeSeries != null) {
          return timeSeries.entries.take(30).map((entry) {
            return {
              "date": entry.key,
              "close": double.parse(entry.value['4. close']),
            };
          }).toList();
        } else {
          throw Exception('No historical data found');
        }
      } else {
        throw Exception('Failed to fetch historical data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
