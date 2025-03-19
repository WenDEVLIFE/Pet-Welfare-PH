import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/RegionModel.dart';
import '../model/ProvinceModel.dart';
import '../model/CityModel.dart';
import '../model/BarangayModel.dart';

class LocationService {
  final String geoUserName = 'wendevlife';
  final String countryGeoId = '1694008'; // Philippines' GeoNames ID

  Future<List<RegionModel>> fetchRegions() async {
    final url = 'http://api.geonames.org/childrenJSON?geonameId=$countryGeoId&username=$geoUserName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('geonames')) {
        return (data['geonames'] as List)
            .where((e) => e['countryCode'] == 'PH') // Ensure it's for the Philippines
            .map((e) => RegionModel(region: e['name'], regionCode: e['geonameId'].toString()))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load regions. Status Code: ${response.statusCode}');
    }
  }

  Future<List<ProvinceModel>> fetchProvinces(String regionCode) async {
    final url = 'http://api.geonames.org/childrenJSON?geonameId=$regionCode&username=$geoUserName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('geonames')) {
        return (data['geonames'] as List)
            .where((e) => e['countryCode'] == 'PH')
            .map((e) => ProvinceModel(provinceName: e['name'], provinceCode: e['geonameId'].toString()))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load provinces. Status Code: ${response.statusCode}');
    }
  }

  Future<List<CityModel>> fetchCities(String provinceCode) async {
    final url = 'http://api.geonames.org/childrenJSON?geonameId=$provinceCode&username=$geoUserName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('geonames')) {
        return (data['geonames'] as List)
            .where((e) => e['countryCode'] == 'PH')
            .map((e) => CityModel(cityName: e['name'], cityCode: e['geonameId'].toString()))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load cities. Status Code: ${response.statusCode}');
    }
  }

  Future<List<BarangayModel>> fetchBarangays(String cityCode) async {
    final url = 'http://api.geonames.org/childrenJSON?geonameId=$cityCode&username=$geoUserName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('geonames')) {
        return (data['geonames'] as List)
            .where((e) => e['countryCode'] == 'PH')
            .map((e) => BarangayModel(barangayName: e['name'], municipalityCode: e['geonameId'].toString()))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load barangays. Status Code: ${response.statusCode}');
    }
  }
}
