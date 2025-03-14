import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/BreedModel.dart';

class PetAPI {
  static const String catApiUrl = "https://api.thecatapi.com/v1/breeds";
  static const String dogApiUrl = "https://api.thedogapi.com/v1/breeds";

  // Fetch Cat Breeds
  static Future<List<Breed>> fetchCatBreeds() async {
    final response = await http.get(Uri.parse(catApiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Breed.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load cat breeds");
    }
  }

  // Fetch Dog Breeds
  static Future<List<Breed>> fetchDogBreeds() async {
    final response = await http.get(Uri.parse(dogApiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Breed.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load dog breeds");
    }
  }
}
