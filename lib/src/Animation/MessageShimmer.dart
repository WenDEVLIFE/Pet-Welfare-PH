import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MessageShimmer extends StatelessWidget {
  final double width;
  final double height;

  const MessageShimmer({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
            ),
            title: Container(
              width: width * 0.6,
              height: 10,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 6),
            ),
            subtitle: Container(
              width: width * 0.4,
              height: 10,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
