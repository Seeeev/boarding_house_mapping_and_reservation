import 'package:boarding_house_mapping_v2/models/tenant_raiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;
import 'package:rating_dialog/rating_dialog.dart';

class Rate extends StatelessWidget {
  const Rate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.rate_review),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return RatingDialog(
                title: Text(
                  'Boarding House Mapping and Reservatin System',
                  textAlign: TextAlign.center,
                ),
                commentHint: 'Rate your stay',
                initialRating: 5,
                starSize: 30,
                image: Image.asset(
                  'assets/logo/logo.png',
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
                submitButtonText: 'Submit',
                onSubmitted: (response) async {
                  String feedback = response.comment;
                  int rating = response.rating.toInt();
                  String date = DateTime.now().toString();
                  String uid = globals.auth.currentUser!.uid;
                  String displayName = globals.auth.currentUser!.displayName!;

                  RatingModel data = RatingModel(
                      uid: uid,
                      displayName: displayName,
                      feedback: feedback,
                      date: date,
                      rating: rating);

                  await data.storeRating(data.getFeedback());

                  Get.snackbar('Rating Submitted', 'Thank you for your rating!',
                      colorText: Colors.white);
                },
              );
            });
      },
    );
  }
}
