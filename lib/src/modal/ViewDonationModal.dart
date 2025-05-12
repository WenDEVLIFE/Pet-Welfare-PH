import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/DonateViewModel.dart';

/// TODO: implement the ui
class ViewDonation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    DonateViewModel donateViewModel = Provider.of<DonateViewModel>(context);

    return Container(
        padding: const EdgeInsets.all(16.0),
    decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    ),
    ),

    );

  }

}