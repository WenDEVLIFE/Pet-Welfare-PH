import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../model/BarangayModel.dart';
import '../../model/BarangayModel.dart';
import '../../model/BreedModel.dart';
import '../../model/CityModel.dart';
import '../../model/ProvinceModel.dart';
import '../../model/RegionModel.dart';
import '../../services/MapTilerKey.dart';
import '../../utils/AppColors.dart';
import '../../utils/ToastComponent.dart';
import '../../view_model/CreatePostViewModel.dart';

class CreatePostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CreatePostViewModel createPostViewModel = Provider.of<CreatePostViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          createPostViewModel.selectedChip == "Missing Pets"
              ? 'Post a missing pets'
              : createPostViewModel.selectedChip == "Found Pets"
              ? 'Post a found pets'
              : createPostViewModel.selectedChip == "Pet Adoption"
              ? 'Post for adoption'
              : 'Create a post',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  createPostViewModel.selectedChip == "Missing Pets"
                      ? 'Enter the details of the missing pet'
                      : createPostViewModel.selectedChip == "Found Pets"
                      ? 'Enter the details of the found pet'
                      : createPostViewModel.selectedChip == "Pet Adoption"
                      ? 'Enter the details of the pet for adoption'
                      : 'Create a post',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.3,
                child: TextField(
                  controller: createPostViewModel.postController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your post here...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.3,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Upload a picture',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'SmoochSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => createPostViewModel.pickImage(),
                            child: Container(
                              width: screenWidth * 0.2,
                              height: screenHeight * 0.1,
                              color: Colors.grey[200],
                              child: const Icon(Icons.add_a_photo, color: Colors.grey),
                            ),
                          ),
                          ...createPostViewModel.images.map((image) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  width: 100,
                                  height: 100,
                                  child: Image.file(image, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      createPostViewModel.removeImage(image);
                                    },
                                    child: Container(
                                      color: Colors.black54,
                                      child: const Icon(Icons.close, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select a category',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.085,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  border: Border.all(color: AppColors.gray, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: createPostViewModel.selectedChip,
                    items: createPostViewModel.chipLabels1.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SmoochSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      createPostViewModel.setSelectRole(newValue!);
                    },
                    dropdownColor: AppColors.gray,
                    iconEnabledColor: Colors.grey,
                    style: const TextStyle(color: Colors.white),
                    selectedItemBuilder: (BuildContext context) {
                      return createPostViewModel.chipLabels1.map<Widget>((String item) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'SmoochSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    isExpanded: true,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            if (createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets") ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    createPostViewModel.selectedChip == "Missing Pets"
                        ? 'Select a location for missing pets'
                        : createPostViewModel.selectedChip == "Found Pets"
                        ? 'Select a location for found pets'
                        : 'Select a location for found pets',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    child: MaplibreMap(
                      styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(createPostViewModel.lat, createPostViewModel.long),
                        zoom: 15.0,
                      ),
                      onMapCreated: (MaplibreMapController controller) async {
                        createPostViewModel.mapController = controller;
                        await createPostViewModel.loadMarkerImage(controller); // Load custom marker
                        if (createPostViewModel.selectedLocation != null) {
                          createPostViewModel.addPin(createPostViewModel.selectedLocation!);
                        }
                      },
                      onMapClick: (point, coordinates) async {
                        if (createPostViewModel.mapController == null) return;

                        // Update location
                        createPostViewModel.updateLocation(coordinates);

                        // Remove previous markers
                        await createPostViewModel.mapController!.clearSymbols();

                        // Add new marker
                        await createPostViewModel.mapController!.addSymbol(SymbolOptions(
                          geometry: coordinates,
                          iconImage: "custom_marker", // Use loaded image
                          iconSize: 1.5,
                        ));

                        print("Pinned Location: ${coordinates.latitude}, ${coordinates.longitude}");
                        ToastComponent().showMessage(AppColors.orange, 'Pinned Location: ${coordinates.latitude}, ${coordinates.longitude}');
                      },
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.99,
                          height: screenHeight * 0.08,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.transparent, width: 7),
                          ),
                          child: TextField(
                            controller: createPostViewModel.searchController,
                            focusNode: createPostViewModel.focusNode,
                            onChanged: (query) {
                              createPostViewModel.searchLocation(query);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              prefixIcon: const Icon(Icons.search, color: Colors.black),
                              suffixIcon: createPostViewModel.searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.black),
                                onPressed: () {
                                  createPostViewModel.searchController.clear();
                                  createPostViewModel.removePins();
                                  createPostViewModel.showDropdown = false; // Hide dropdown when cleared
                                },
                              )
                                  : null,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.transparent, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.orange, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.orange, width: 2),
                              ),
                              hintText: 'Search an address....',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                            ),
                            style: const TextStyle(
                              fontFamily: 'LeagueSpartan',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (createPostViewModel.showDropdown)
                          Consumer<CreatePostViewModel>(
                            builder: (context, viewModel, child) {
                              return Container(
                                height: screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Set the background color
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                  itemCount: viewModel.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final result = viewModel.searchResults[index];
                                    return ListTile(
                                      title: Text(result['display_name']),
                                      onTap: () {
                                        createPostViewModel.searchController.text = result['display_name'];
                                        createPostViewModel.showDropdown = false;
                                        createPostViewModel.focusNode.unfocus();
                                        createPostViewModel.addPin(LatLng(
                                          double.parse(result['lat']),
                                          double.parse(result['lon']),
                                        ));
                                        createPostViewModel.mapController?.animateCamera(
                                          CameraUpdate.newLatLng(
                                            LatLng(
                                              double.parse(result['lat']),
                                              double.parse(result['lon']),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets") ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    createPostViewModel.selectedChip == "Missing Pets"
                        ? 'Select a date of the missing pets'
                        : createPostViewModel.selectedChip == "Found Pets"
                        ? 'Select a date of the found pets'
                        : 'Select a date of the found pets',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: createPostViewModel.dateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      createPostViewModel.dateController.text = date.toLocal().toString().split(' ')[0];
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select a date...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pet Age',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: createPostViewModel.ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter the pet age...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pet Color',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: createPostViewModel.colorController,
                  decoration: InputDecoration(
                    hintText: 'Enter the pet color...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select a Pet Type',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:  Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    border: Border.all(color: AppColors.gray, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: createPostViewModel.selectedPetType,
                      hint: const Text('Select Pet Type'),
                      items: createPostViewModel.petTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'SmoochSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        createPostViewModel.setPetType(newValue);
                      },
                      dropdownColor: AppColors.gray,
                      iconEnabledColor: Colors.grey,
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
              if (createPostViewModel.selectedPetType == 'Cat') ...[
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cat Breed',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gray,
                      border: Border.all(color: AppColors.gray, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Breed>(
                        value: createPostViewModel.selectPedBreed,
                        hint: const Text('Select Cat Breed'),
                        items: createPostViewModel.catBreeds.map((Breed breed) {
                          return DropdownMenuItem<Breed>(
                            value: breed,
                            child: Text(
                              breed.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'SmoochSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Breed? newValue) {
                          createPostViewModel.selectedBreed(newValue);
                        },
                        dropdownColor: AppColors.gray,
                        iconEnabledColor: Colors.grey,
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
              ],
              if (createPostViewModel.selectedPetType == 'Dog') ...[
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dog Breed',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gray,
                      border: Border.all(color: AppColors.gray, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Breed>(
                        value: createPostViewModel.selectPedBreed,
                        hint: const Text('Select Dog Breed'),
                        items: createPostViewModel.dogBreeds.map((Breed breed) {
                          return DropdownMenuItem<Breed>(
                            value: breed,
                            child: Text(
                              breed.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'SmoochSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Breed? newValue) {
                          createPostViewModel.selectedBreed(newValue);
                        },
                        dropdownColor: AppColors.gray,
                        iconEnabledColor: Colors.grey,
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Region, Province, City and Barangay',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        border: Border.all(color: AppColors.gray, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<RegionModel>(
                          value: createPostViewModel.selectedRegion,
                          hint: const Text('Select Region'),
                          items: createPostViewModel.regions.map((RegionModel region) {
                            return DropdownMenuItem<RegionModel>(
                              value: region,
                              child: Text(
                                region.region,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (RegionModel? newValue) {
                            createPostViewModel.setSelectedRegion(newValue);
                          },
                          dropdownColor: AppColors.gray,
                          iconEnabledColor: Colors.grey,
                          isExpanded: true,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    if (createPostViewModel.selectedRegion != null)
                      SizedBox(height: screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        border: Border.all(color: AppColors.gray, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ProvinceModel>(
                          value: createPostViewModel.selectedProvince,
                          hint: const Text('Select Province'),
                          items: createPostViewModel.provinces.map((ProvinceModel province) {
                            return DropdownMenuItem<ProvinceModel>(
                              value: province,
                              child: Text(
                                province.provinceName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (ProvinceModel? newValue) {
                            createPostViewModel.setSelectedProvince(newValue);
                          },
                          dropdownColor: AppColors.gray,
                          iconEnabledColor: Colors.grey,
                          isExpanded: true,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    if (createPostViewModel.selectedProvince != null)
                      SizedBox(height: screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        border: Border.all(color: AppColors.gray, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CityModel>(
                          value: createPostViewModel.selectedCity,
                          hint: const Text('Select City'),
                          items: createPostViewModel.cities.map((CityModel city) {
                            return DropdownMenuItem<CityModel>(
                              value: city,
                              child: Text(
                                city.cityName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (CityModel? newValue) {
                            createPostViewModel.setSelectedCity(newValue);
                          },
                          dropdownColor: AppColors.gray,
                          iconEnabledColor: Colors.grey,
                          isExpanded: true,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    if (createPostViewModel.selectedCity != null)
                      SizedBox(height: screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        border: Border.all(color: AppColors.gray, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<BarangayModel>(
                          value: createPostViewModel.selectedBarangay,
                          hint: const Text('Select Barangay'),
                          items: createPostViewModel.barangays.map((BarangayModel barangay) {
                            return DropdownMenuItem<BarangayModel>(
                              value: barangay,
                              child: Text(
                                barangay.barangayName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (BarangayModel? newValue) {
                            createPostViewModel.setSelectedBarangay(newValue);
                          },
                          dropdownColor: AppColors.gray,
                          iconEnabledColor: Colors.grey,
                          isExpanded: true,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    createPostViewModel.selectedChip == "Missing Pets"
                        ? 'Select a Street Address, Building, House No for found pets'
                        : createPostViewModel.selectedChip == "Found Pets"
                        ? 'Select a Street Address, Building, House No for found pets'
                        : 'Select a Street Address, Building, House No for found pets',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: createPostViewModel.address,
                  decoration: InputDecoration(
                    hintText: 'Street, Building, House No...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                ),
              ),
            ],
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  createPostViewModel.PostNow(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text(
                  'Post Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}