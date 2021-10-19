import 'package:boarding_house_mapping_v2/admin/widgets/appbar.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/drawer.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/owner_form.dart';
import 'package:boarding_house_mapping_v2/controllers/admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import 'package:get/get.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;
import 'package:faker/faker.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  static final _ownerList = [
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
    {
      'lat': 12.1253465,
      'lng': 12.46576546776,
      'uid': '5648578097086546',
      'screenName': Faker().person.name(),
      'address': Faker().address.streetAddress(),
      'content': Faker().lorem
    },
  ];
  //  _showListofOwners() {
  //   // return Container();

  //   // FirebaseFirestore.instance
  //   //     .collection('owners')
  //   //     .get()
  //   //     .then((QuerySnapshot querySnapshot) {
  //   //   querySnapshot.docs.forEach((doc) {
  //   //     FirebaseFirestore.instance
  //   //         .collection(doc['uid'])
  //   //         .get()
  //   //         .then((QuerySnapshot querySnapshot) {
  //   //       querySnapshot.docs.forEach((doc) {
  //   //         print(doc.data());
  //   //       });
  //   //     });
  //   //   });
  //   // });
  //   // return Container();
  // }

  Widget _showListofOwners(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('boarding_houses')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildWidget(context, snapshot);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(
                child: Text('No landlords are registered at the moment'));
          }
          if (snapshot.hasData) {
            return _buildWidget(context, snapshot);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildWidget(context, snapshot) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 3),
      primary: false,
      padding: EdgeInsets.all(5),
      shrinkWrap: true,
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) => Card(
        child: InkWell(
          onLongPress: () => print(snapshot.data!.docs[index]['ownerName']),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      child: Text(
                        snapshot.data!.docs[index]['ownerName'].toString()[0],
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.docs[index]['ownerName'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.data!.docs[index]['bldgName'])
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  snapshot.data!.docs[index]['address'].toString(),
                ),
                Text(snapshot.data!.docs[index]['lat'].toString() +
                    " " +
                    snapshot.data!.docs[index]['lng'].toString())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerList(context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Row(
            children: [
              Text('Owners', style: TextStyle(color: Colors.black45)),
              Expanded(child: Container()),
              Text('Sort by', style: TextStyle(color: Colors.black45)),
            ],
          ),
        ),
        _showListofOwners(context)
      ],
    ));
  }

  Widget _buildFeedbacks(context) {
    return SliverToBoxAdapter(
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('feedbacks').snapshots(),
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
                  itemBuilder: (context, index) => Card(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            child: Text(
                              snapshot.data!.docs[index]['displayName']
                                  .toString()[0],
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  RatingStars(
                                    value: snapshot.data!.docs[index]['rating']
                                        .toDouble(),
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
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    valueLabelPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 8),
                                    valueLabelMargin:
                                        const EdgeInsets.only(right: 8),
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
                                    child: Text(
                                        snapshot.data!.docs[index]['date'],
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  static final _adminController = Get.put(AdminController());
  static final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey =
      GlobalKey();

  static final _bottomNavIcons = <Widget>[
    Icon(Icons.add, size: 30, color: Colors.white),
    Icon(Icons.list, size: 30, color: Colors.white),
    Icon(Icons.feedback_rounded, size: 30, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          key: _bottomNavigationKey,
          onTap: (index) {
            _adminController.updateIndex(index);
          },
          color: Colors.black87,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.black87,
          items: _bottomNavIcons,
        ),
        drawer: Drawer(
          child: buildDrawer(),
        ),
        body: Obx(() => CustomScrollView(
              slivers: [
                buildAppbar(),
                _adminController.index.value == 0
                    // ? buildOwnerForm(context)
                    ? getForm(context)
                    : _adminController.index.value == 1
                        ? _buildOwnerList(context)
                        : _buildFeedbacks(context),
                // _buildOwnerList(),
              ],
            )));
  }
}
