import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapTilerKey{
  static final String apikey = dotenv.env['MAPTILER_API_KEY'] ?? '';
  static const String styleUrl = 'https://api.maptiler.com/maps/streets-v2/style.json';
}