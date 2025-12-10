import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<String> fetchStatus() async {
    try {
      final res = await http.get(Uri.parse('https://api.github.com/zen')).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return 'API error: ${res.statusCode}';
      }
    } catch (e) {
      return 'API error: $e';
    }
  }
}
