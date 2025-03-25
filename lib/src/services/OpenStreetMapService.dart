import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenStreetMapService {
  Future<List<Map<String, dynamic>>> fetchOpenStreetMapData(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&addressdetails=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }
}