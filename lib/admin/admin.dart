import 'package:boarding_house_mapping_v2/admin/widgets/appbar.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/drawer.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/owner_form.dart';
import 'package:boarding_house_mapping_v2/controllers/admin_controller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Widget _showListofOwners() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 3),
      primary: false,
      padding: EdgeInsets.all(5),
      shrinkWrap: true,
      itemCount: _ownerList.length,
      itemBuilder: (context, index) => Card(
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
                      _ownerList[index]['screenName'].toString()[0],
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      _ownerList[index]['screenName'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Text(
                _ownerList[index]['address'].toString(),
              ),
              Text(_ownerList[index]['lat'].toString() +
                  " " +
                  _ownerList[index]['lng'].toString())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerList() {
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
        _showListofOwners()
      ],
    ));
  }

  static final _adminController = Get.put(AdminController());
  static final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey =
      GlobalKey();

  static final _bottomNavIcons = <Widget>[
    Icon(Icons.add, size: 30, color: Colors.white),
    Icon(Icons.list, size: 30, color: Colors.white),
    Icon(Icons.compare_arrows, size: 30, color: Colors.white),
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
                    ? buildOwnerForm(context)
                    : _buildOwnerList(),
                // _buildOwnerList(),
              ],
            )));
  }
}
