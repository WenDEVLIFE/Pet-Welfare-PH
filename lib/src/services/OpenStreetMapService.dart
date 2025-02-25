import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenStreetMapService{
  Future<List<Map<String, dynamic>>> fetchOpenStreetMapData(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}