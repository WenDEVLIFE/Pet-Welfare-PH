import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/RegionModel.dart';
import '../model/ProvinceModel.dart';
import '../model/CityModel.dart';
import '../model/BarangayModel.dart';

class LocationService {
  Future<List<RegionModel>> fetchRegions() async {
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/regions'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => RegionModel(region: e['name'], regionCode: e['code'])).toList();
    } else {
      throw Exception('Failed to load regions');
    }
  }

  Future<List<ProvinceModel>> fetchProvinces(String regionCode) async {
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/provinces'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .where((e) => e['regionCode'].toString() == regionCode)
          .map((e) => ProvinceModel(provinceName: e['name'], provinceCode: e['code']))
          .toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<CityModel>> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/cities-municipalities'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .where((e) => e['provinceCode'] == provinceCode)
          .map((e) => CityModel(cityName: e['name'], cityCode: e['code']))
          .toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<List<BarangayModel>> fetchBarangays(String municipalityCode) async {
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/barangays'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .where((e) => e['municipalityCode'] == municipalityCode)
          .map((e) => BarangayModel(barangayName: e['name'], municipalityCode: e['code']))
          .toList();
    } else {
      throw Exception('Failed to load barangays');
    }
  }
}