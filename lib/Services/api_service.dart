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
}
