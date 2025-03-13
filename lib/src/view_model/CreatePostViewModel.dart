import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'dart:io';

import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CreatePostViewModel extends ChangeNotifier {
  final TextEditingController postController = TextEditingController();
  final TextEditingController  dateController = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController petName = TextEditingController();

  final List<File> _images = [];
  var collarList = ['Select a collar','With Collar', 'Without Collar'];
  var catBreed = [
    'Select a breed',
    'Abyssinian',
    'American Bobtail',
    'American Curl',
    'American Shorthair',
    'American Wirehair',
    'Balinese',
    'Bengal',
    'Birman',
    'Bombay',
    'British Shorthair',
    'Burmese',
    'Burmilla',
    'Chartreux',
    'Cornish Rex',
    'Devon Rex',
    'Egyptian Mau',
    'European Shorthair',
    'Exotic Shorthair',
    'Himalayan',
    'Japanese Bobtail',
    'Javanese',
    'Korat',
    'LaPerm',
    'Maine Coon',
    'Manx',
    'Munchkin',
    'Norwegian Forest Cat',
    'Ocicat',
    'Oriental Shorthair',
    'Persian',
    'Peterbald',
    'Pixie-bob',
    'Ragdoll',
    'Russian Blue',
    'Scottish Fold',
    'Selkirk Rex',
    'Siamese',
    'Siberian',
    'Singapura',
    'Snowshoe',
    'Somali',
    'Sphynx',
    'Tonkinese',
    'Toyger',
    'Turkish Angora',
    'Turkish Van',
    'Puspin'  // Mixed-breed in the Philippines
  ];

  var dogBreed = [
    'Select a breed',
    'Affenpinscher',
    'Afghan Hound',
    'Airedale Terrier',
    'Akita',
    'Alaskan Malamute',
    'American Bulldog',
    'American Eskimo Dog',
    'American Pit Bull Terrier',
    'American Staffordshire Terrier',
    'Anatolian Shepherd Dog',
    'Australian Cattle Dog',
    'Australian Shepherd',
    'Australian Terrier',
    'Basenji',
    'Basset Hound',
    'Beagle',
    'Bearded Collie',
    'Beauceron',
    'Bedlington Terrier',
    'Belgian Malinois',
    'Belgian Sheepdog',
    'Belgian Tervuren',
    'Bernese Mountain Dog',
    'Bichon Frise',
    'Black and Tan Coonhound',
    'Bloodhound',
    'Border Collie',
    'Border Terrier',
    'Borzoi',
    'Boston Terrier',
    'Bouvier des Flandres',
    'Boxer',
    'Boykin Spaniel',
    'Briard',
    'Brittany Spaniel',
    'Bull Terrier',
    'Bulldog',
    'Bullmastiff',
    'Cairn Terrier',
    'Cavalier King Charles Spaniel',
    'Chesapeake Bay Retriever',
    'Chihuahua',
    'Chinese Crested',
    'Chow Chow',
    'Cocker Spaniel',
    'Collie',
    'Coonhound',
    'Corgi',
    'Dachshund',
    'Dalmatian',
    'Doberman Pinscher',
    'Dogo Argentino',
    'English Bulldog',
    'English Setter',
    'English Springer Spaniel',
    'French Bulldog',
    'German Shepherd',
    'Golden Retriever',
    'Great Dane',
    'Great Pyrenees',
    'Greyhound',
    'Havanese',
    'Irish Setter',
    'Irish Wolfhound',
    'Jack Russell Terrier',
    'Labrador Retriever',
    'Lhasa Apso',
    'Maltese',
    'Mastiff',
    'Miniature Pinscher',
    'Miniature Schnauzer',
    'Newfoundland',
    'Papillon',
    'Pekingese',
    'Pembroke Welsh Corgi',
    'Pit Bull',
    'Pointer',
    'Pomeranian',
    'Poodle',
    'Portuguese Water Dog',
    'Pug',
    'Puli',
    'Puspin', // Mixed-breed in the Philippines
    'Rottweiler',
    'Saint Bernard',
    'Samoyed',
    'Schnauzer',
    'Scottish Terrier',
    'Shetland Sheepdog',
    'Shih Tzu',
    'Siberian Husky',
    'Staffordshire Bull Terrier',
    'Tibetan Mastiff',
    'Tibetan Terrier',
    'Weimaraner',
    'West Highland White Terrier',
    'Whippet',
    'Yorkshire Terrier'
  ];

  var chipLabels1 = [
    'Pet Appreciation',
    'Missing Pets',
    'Found Pets',
    'Find a Home: Rescue & Shelter',
    'Call for Aid',
    'Paw-some Experience',
    'Pet Adoption',
    'Protect Our Pets: Report Abuse',
    'Caring for Pets: Vet & Travel Insights',
    'Community Announcements'
  ];

  final PostRepository postRepository = PostRepositoryImpl();

  String selectedChip = 'Pet Appreciation';

  List<File> get images => _images;

  // This is for the maps selection
  LatLng? selectedLocation;
  bool _locationInitialized = false;
  double lat = 0.0;
  double long = 0.0;
  double newlat = 0.0;
  double newlong = 0.0;
  MaplibreMapController? mapController;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _images.add(File(image.path));
      notifyListeners();
    }
  }

  void removeImage(File image) {
    _images.remove(image);
    notifyListeners();
  }

  void setSelectRole(String selectedValue) {
    selectedChip = selectedValue;
    notifyListeners();
  }

  void clearPost() {
    postController.clear();
    _images.clear();
    selectedChip = 'Pet Appreciation';
    notifyListeners();
  }

  Future<void> PostNow(BuildContext context) async {

    if(selectedChip =='Pet Appreciation'){
      if (postController.text.isEmpty) {
        // Implement post functionality here
        ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
      }

      else if (_images.isEmpty) {
        // Implement post functionality here
        ToastComponent().showMessage(Colors.red, 'Please select an image');
      }

      else {
        // Implement post functionality here
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(max: 100, msg: 'Posting...');
        try{
          await postRepository.uploadPost(postController.text, _images, selectedChip);
          ToastComponent().showMessage(Colors.green, 'Post successful');
          clearPost();
        }
        catch(e){
          ToastComponent().showMessage(Colors.red, 'Failed to upload post: $e');
        }
        finally{
          pd.close();
        }
      }
    }
  }
}