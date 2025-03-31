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
      return getDefaultCatBreeds();
    }
  }

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

      ToastComponent().showMessage(Colors.red, "Failed to load dog breeds. Showing defaults.");
      return getDefaultDogBreeds();
    }
  }

  static List<Breed> getDefaultCatBreeds() {
    return [
      Breed(id: "1", name: "Puspin", temperament: "Friendly, Adaptable", imageUrl: ""),
      Breed(id: "2", name: "Siamese", temperament: "Social, Vocal", imageUrl: ""),
      Breed(id: "3", name: "Persian", temperament: "Calm, Affectionate", imageUrl: ""),
      Breed(id: "4", name: "Persian x Siamese", temperament: "Calm, Social", imageUrl: ""),
      Breed(id: "5", name: "Bengal", temperament: "Active, Energetic", imageUrl: ""),
      Breed(id: "6", name: "Maine Coon", temperament: "Intelligent, Playful", imageUrl: ""),
      Breed(id: "7", name: "British Shorthair", temperament: "Easygoing, Affectionate", imageUrl: ""),
      Breed(id: "8", name: "Ragdoll", temperament: "Gentle, Affectionate", imageUrl: ""),
      Breed(id: "9", name: "Sphynx", temperament: "Friendly, Energetic", imageUrl: ""),
      Breed(id: "10", name: "Burmese", temperament: "Social, Playful", imageUrl: ""),
      Breed(id: "11", name: "Scottish Fold", temperament: "Quiet, Loving", imageUrl: ""),
      Breed(id: "12", name: "Russian Blue", temperament: "Shy, Loyal", imageUrl: ""),
      Breed(id: "13", name: "Munchkin", temperament: "Playful, Friendly", imageUrl: ""),
      Breed(id: "14", name: "Himalayan", temperament: "Calm, Gentle", imageUrl: ""),
      Breed(id: "15", name: "Others", temperament: "Varied", imageUrl: ""),
    ];
  }

  static List<Breed> getDefaultDogBreeds() {
    return [
      Breed(id: "16", name: "Aspin", temperament: "Friendly, Adaptable", imageUrl: ""),
      Breed(id: "17", name: "Pomeranian", temperament: "Playful, Lively", imageUrl: ""),
      Breed(id: "18", name: "Chihuahua", temperament: "Bold, Energetic", imageUrl: ""),
      Breed(id: "19", name: "Husky", temperament: "Energetic, Outgoing", imageUrl: ""),
      Breed(id: "20", name: "Golden Retriever", temperament: "Intelligent, Friendly", imageUrl: ""),
      Breed(id: "21", name: "Labrador", temperament: "Friendly, Outgoing", imageUrl: ""),
      Breed(id: "22", name: "Border Collie", temperament: "Intelligent, Energetic", imageUrl: ""),
      Breed(id: "23", name: "German Shepherd", temperament: "Courageous, Obedient", imageUrl: ""),
      Breed(id: "24", name: "Bulldog", temperament: "Docile, Willful", imageUrl: ""),
      Breed(id: "25", name: "Beagle", temperament: "Curious, Gentle", imageUrl: ""),
      Breed(id: "26", name: "Dachshund", temperament: "Curious, Brave", imageUrl: ""),
      Breed(id: "27", name: "Pug", temperament: "Loving, Mischievous", imageUrl: ""),
      Breed(id: "28", name: "Rottweiler", temperament: "Protective, Confident", imageUrl: ""),
      Breed(id: "29", name: "Corgi", temperament: "Playful, Friendly", imageUrl: ""),
      Breed(id: "30", name: "Shih Tzu", temperament: "Affectionate, Friendly", imageUrl: ""),
      Breed(id: "31", name: "Shiba Inu", temperament: "Alert, Bold", imageUrl: ""),
      Breed(id: "32", name: "Samoyed", temperament: "Friendly, Gentle", imageUrl: ""),
      Breed(id: "33", name: "Doberman", temperament: "Intelligent, Alert", imageUrl: ""),
      Breed(id: "34", name: "Others", temperament: "Varied", imageUrl: ""),
    ];
  }
}