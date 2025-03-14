import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../model/BreedModel.dart';

class PetAPI {
  static const String catApiUrl = "https://api.thecatapi.com/v1/breeds";
  static const String dogAPIKey = "live_wXofA5Eb11w8o7VmTkDH4EvegD9U17AQLR4t9U2cRUztlSjw8yzOyj0AxMktsFoH";
  static const String dogApiUrl = "https://api.thedogapi.com/v1/breeds";

  static Future<List<Breed>> fetchCatBreeds() async {
    try {
      final response = await http.get(Uri.parse(catApiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Breed.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load cat breeds: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching cat breeds: $e");
      }

      ToastComponent().showMessage(Colors.red, "Failed to load cat breeds. Showing defaults.");

      // Default Philippine & International Cat Breeds
      return [
        // 🇵🇭 Philippine Native Cat
        Breed(id: "1", name: "Pusang Pinoy (Puspin)", temperament: "Friendly, Adaptable", imageUrl: ""),

        // 🌍 International Breeds
        Breed(id: "2", name: "Persian", temperament: "Calm, Affectionate", imageUrl: ""),
        Breed(id: "3", name: "Maine Coon", temperament: "Intelligent, Playful", imageUrl: ""),
        Breed(id: "4", name: "Siamese", temperament: "Social, Vocal", imageUrl: ""),
        Breed(id: "5", name: "Bengal", temperament: "Active, Energetic", imageUrl: ""),
        Breed(id: "6", name: "Ragdoll", temperament: "Gentle, Affectionate", imageUrl: ""),
        Breed(id: "7", name: "Scottish Fold", temperament: "Quiet, Loving", imageUrl: ""),
        Breed(id: "8", name: "British Shorthair", temperament: "Easygoing, Affectionate", imageUrl: ""),
        Breed(id: "9", name: "Sphynx", temperament: "Friendly, Energetic", imageUrl: ""),
        Breed(id: "10", name: "Russian Blue", temperament: "Shy, Loyal", imageUrl: ""),
        Breed(id: "11", name: "Others", temperament: "Shy, Loyal", imageUrl: ""),
      ];
    }
  }


  // Fetch Dog Breeds
  static Future<List<Breed>> fetchDogBreeds() async {
    try {
      final response = await http.get(
        Uri.parse(dogApiUrl),
        headers: {"x-api-key": dogAPIKey},
      );

      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Breed.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load dog breeds: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching dog breeds: $e");
      }

      // Default Philippine & International Breeds
      return [
        // 🇵🇭 Philippine Native Breeds
        Breed(id: "1", name: "Aspin (Asong Pinoy)", temperament: "Friendly, Adaptable", imageUrl: ""),
        Breed(id: "2", name: "Philippine Bulldog", temperament: "Strong, Protective", imageUrl: ""),
        Breed(id: "3", name: "Philippine Doberman", temperament: "Intelligent, Alert", imageUrl: ""),
        Breed(id: "4", name: "Palawan Dog", temperament: "Agile, Loyal", imageUrl: ""),
        Breed(id: "5", name: "Bantay Dog", temperament: "Protective, Alert", imageUrl: ""),

        // 🌍 International Large Breeds
        Breed(id: "6", name: "Labrador Retriever", temperament: "Friendly, Outgoing", imageUrl: ""),
        Breed(id: "7", name: "Golden Retriever", temperament: "Intelligent, Friendly", imageUrl: ""),
        Breed(id: "8", name: "German Shepherd", temperament: "Courageous, Obedient", imageUrl: ""),
        Breed(id: "9", name: "Rottweiler", temperament: "Protective, Confident", imageUrl: ""),
        Breed(id: "10", name: "Siberian Husky", temperament: "Energetic, Outgoing", imageUrl: ""),

        // 🌍 International Medium Breeds
        Breed(id: "11", name: "Bulldog", temperament: "Docile, Willful", imageUrl: ""),
        Breed(id: "12", name: "Beagle", temperament: "Curious, Gentle", imageUrl: ""),
        Breed(id: "13", name: "Border Collie", temperament: "Intelligent, Energetic", imageUrl: ""),
        Breed(id: "14", name: "Shiba Inu", temperament: "Alert, Bold", imageUrl: ""),
        Breed(id: "15", name: "Cocker Spaniel", temperament: "Friendly, Affectionate", imageUrl: ""),

        // 🌍 International Small Breeds
        Breed(id: "16", name: "Pomeranian", temperament: "Playful, Lively", imageUrl: ""),
        Breed(id: "17", name: "Chihuahua", temperament: "Bold, Energetic", imageUrl: ""),
        Breed(id: "18", name: "Shih Tzu", temperament: "Affectionate, Friendly", imageUrl: ""),
        Breed(id: "19", name: "Pug", temperament: "Loving, Mischievous", imageUrl: ""),
        Breed(id: "20", name: "Dachshund", temperament: "Curious, Brave", imageUrl: ""),
        Breed(id: "21", name: "Others", temperament: "Shy, Loyal", imageUrl: ""),
      ];
    }
  }


}
