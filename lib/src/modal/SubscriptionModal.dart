import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionModal extends StatefulWidget {

  const SubscriptionModal( {Key? key}) : super(key: key);

  @override
  _SubscriptionModalState createState() => _SubscriptionModalState();
}

class _SubscriptionModalState extends State<SubscriptionModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Subscribe to our Newsletter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Stay updated with the latest news and offers.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle subscription logic here
              Navigator.pop(context);
            },
            child: Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}