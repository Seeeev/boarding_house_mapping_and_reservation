import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';

class BuildTenantFeedbacks extends StatelessWidget {
  const BuildTenantFeedbacks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Text('Tenant Ratings', style: TextStyle(color: Colors.black45)),
                Expanded(child: Container()),
                Text('Sort by', style: TextStyle(color: Colors.black45)),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tenant_ratings')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      primary: false,
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        print('data');
                        print(snapshot.data!.docs[index].data());
                        return Dismissible(
                          key:
                              Key(snapshot.data!.docs[index].data().toString()),
                          child: _buildCard(snapshot, index),
                          direction: DismissDirection.endToStart,
                          background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 10),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                          onDismissed: (direction) {
                            snapshot.data!.docs[index].reference.delete();
                            Get.snackbar('Delete', 'Rating deleted.',
                                colorText: Colors.white);
                          },
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildCard(snapshot, index) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: Text(
                snapshot.data!.docs[index]['displayName'].toString()[0],
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!.docs[index]['displayName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RatingStars(
                      value: snapshot.data!.docs[index]['rating'].toDouble(),
                      starBuilder: (index, color) => Icon(
                        Icons.star,
                        color: color,
                      ),
                      starCount: 5,
                      starSize: 20,
                      valueLabelColor: const Color(0xff9b9b9b),
                      valueLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      valueLabelRadius: 10,
                      maxValue: 5,
                      starSpacing: 2,
                      maxValueVisibility: true,
                      valueLabelVisibility: true,
                      animationDuration: Duration(milliseconds: 1000),
                      valueLabelPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 8),
                      valueLabelMargin: const EdgeInsets.only(right: 8),
                      starOffColor: const Color(0xffe7e8ea),
                      starColor: Colors.yellow,
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Text(
                        snapshot.data!.docs[index]['feedback'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(snapshot.data!.docs[index]['date'],
                          style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
