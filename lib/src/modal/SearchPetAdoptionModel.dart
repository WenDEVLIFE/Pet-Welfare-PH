import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';
import '../utils/ToastComponent.dart';
import '../view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

class SearchPetAdoptionModel extends StatelessWidget{
  const SearchPetAdoptionModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Text('Search Pet Adoption Model'),
    );
  }
}