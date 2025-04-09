import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';

import '../modal/DonateModal.dart';
import '../modal/ReactionModal.dart';
import '../utils/AppColors.dart';
import '../utils/ReactionUtils.dart';
import '../view/ViewImage.dart';
import '../view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import 'CustomText.dart';

class CallForAidCard extends StatelessWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;

  const CallForAidCard({
    Key? key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

     PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);
    var formattedDate = postViewModel.formatTimestamp(post.timestamp);
     return FutureBuilder<Map<String, dynamic>>(
       future: Future.wait([
         postViewModel.getUserReaction(post.postId),
         postViewModel.getReactionCount(post.postId),
         postViewModel.getCommentCount(post.postId),
       ]).then((results) => {
         'userReaction': results[0],
         'reactionCount': results[1],
         'commentCount': results[2],
       }),
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         }

         if (snapshot.hasError) {
           return Center(child: Text('Error: ${snapshot.error}'));
         }

         var data = snapshot.data!;
         String? userReaction = data['userReaction'];
         bool hasReacted = userReaction != null;
         int reactionCount = data['reactionCount'];
         int commentCount = data['commentCount'];

         return Card(
           margin: const EdgeInsets.all(10),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(10),
                     child: CircleAvatar(
                       radius: screenHeight * 0.03,
                       backgroundImage: CachedNetworkImageProvider(post.profileUrl),
                     ),
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(5),
                         child: Text(
                           post.postOwnerName,
                           style: const TextStyle(
                             fontFamily: 'SmoochSans',
                             color: Colors.black,
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(5),
                         child: Text(
                           formattedDate,
                           style: const TextStyle(
                             fontFamily: 'SmoochSans',
                             color: Colors.black,
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                       ),
                     ],
                   )
                 ],
               ),
               Padding(
                 padding: const EdgeInsets.all(10),
                 child: Text(
                   post.postDescription,
                   style: const TextStyle(
                     fontFamily: 'SmoochSans',
                     color: Colors.black,
                     fontSize: 16,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
               if (post.tags.isNotEmpty) ...[
                 const Padding(
                   padding: EdgeInsets.all(10),
                   child: Text(
                     'Tags',
                     style: TextStyle(
                       fontFamily: 'SmoochSans',
                       color: Colors.black,
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(10),
                   child: Wrap(
                     spacing: 8.0,
                     runSpacing: 4.0,
                     children: post.tags.map((tag) {
                       return Chip(
                         label: Text(tag.name),
                       );
                     }).toList(),
                   ),
                 ),
               ],
               SizedBox(
                 height: screenHeight * 0.3,
                 child: PageView.builder(
                   itemCount: post.imageUrls.length,
                   itemBuilder: (context, imageIndex) {
                     return GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => ViewImage(),
                             settings: RouteSettings(
                               arguments: {
                                 'imageUrls': post.imageUrls,
                                 'initialIndex': imageIndex,
                               },
                             ),
                           ),
                         );
                       },
                       child: Container(
                         width: screenWidth * 0.8,
                         height: screenHeight * 0.5,
                         child: CachedNetworkImage(
                           imageUrl: post.imageUrls[imageIndex],
                           fit: BoxFit.cover,
                         ),
                       ),
                     );
                   },
                 ),
               ),
               ExpansionTile(
                 title: CustomText(
                   text: 'Donation Details',
                   size: 24,
                   color: AppColors.black,
                   weight: FontWeight.w700,
                   align: TextAlign.left,
                   screenHeight: screenHeight,
                   alignment: Alignment.centerLeft,
                 ),
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(10),
                     child: Column(
                       children: [
                         CustomText(
                           text: 'Bank Type:',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: '${post.bankHolder}',
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: 'Bank Holder Name:',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: '${post.bankHolder}',
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: 'Account Number:',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: post.accountNumber,
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: 'Type of Donation:',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: '${post.donationType}',
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: 'Purpose of Raising Funds:',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: '${post.purposeOfDonation}',
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: 'Estimated Amount',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: '₱ ${post.estimatedAmount}',
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: 'Status',
                           size: 20,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                         CustomText(
                           text: '${post.statusDonation}',
                           size: 16,
                           color: AppColors.black,
                           weight: FontWeight.w700,
                           align: TextAlign.left,
                           screenHeight: screenHeight,
                           alignment: Alignment.centerLeft,
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       IconButton(
                         icon: Icon(
                           hasReacted
                               ? ReactionUtils.getReactionIcon(userReaction!)
                               : Icons.thumb_up_outlined,
                           color: hasReacted ? ReactionUtils.getReactionColor(userReaction!) : null,
                         ),
                         onPressed: () async {
                           if (hasReacted) {
                             await postViewModel.removeReaction(post.postId);
                           } else {
                             showModalBottomSheet(
                               context: context,
                               builder: (context) {
                                 return ReactionModal(
                                   onReactionSelected: (reaction) async {
                                     await postViewModel.addReaction(post.postId, reaction);
                                   },
                                 );
                               },
                             );
                           }
                         },
                       ),
                       Text('$reactionCount likes', style: const TextStyle(
                         fontFamily: 'SmoochSans',
                         color: Colors.black,
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       )),
                     ],
                   ),
                   Row(
                     children: [
                       IconButton(
                         icon: const Icon(Icons.comment),
                         onPressed: () {
                           postViewModel.showComments(context, post.postId);
                         },
                       ),
                       Text('$commentCount comments', style: const TextStyle(
                         fontFamily: 'SmoochSans',
                         color: Colors.black,
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       )),
                     ],
                   ),
                   Row(
                     children: [
                       IconButton(
                         icon: const Icon(Icons.pets),
                         onPressed: () {
                           showModalBottomSheet(
                             context: context,
                             isScrollControlled: true,
                             builder: (context) {
                               return DonateModal(post.postId);
                             },
                           );
                         },
                       ),
                       const Text('Donate', style: TextStyle(
                         fontFamily: 'SmoochSans',
                         color: Colors.black,
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       )),
                     ],
                   )
                 ],
               ),
             ],
           ),
         );
       },
     );
  }
}