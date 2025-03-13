import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../utils/AppColors.dart';
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.3,
                child: Column(
                  children: [
                    Expanded(
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