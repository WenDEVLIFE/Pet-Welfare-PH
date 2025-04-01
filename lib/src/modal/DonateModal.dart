import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/DonateViewModel.dart';
import 'package:provider/provider.dart';

import '../widgets/CustomTextField.dart';

class DonateModal extends StatelessWidget {

  final String postId;
  DonateModal(this.postId);
  @override
  Widget build(BuildContext context) {
    final DonateViewModel viewModel = Provider.of<DonateViewModel>(context);
   double screenHeight = MediaQuery.of(context).size.height;
   double screenWidth = MediaQuery.of(context).size.width;

   TextEditingController amount = TextEditingController();
   TextEditingController dateController = TextEditingController();
    return Container(
        padding: const EdgeInsets.all(16.0),
    decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Donation Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        Expanded(child:
            SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Amount Donated',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: nameController,
                    screenHeight: screenHeight,
                    hintText: 'Enter your full name',
                    fontSize: 16,
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          dateController.text = date.toLocal().toString().split(' ')[0];
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
                ],
              ),
            )
        )
      ],

    ),
    );
  }
  
}