import 'package:boarding_house_mapping_v2/controllers/admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;
import 'package:get/get.dart';

final _popupMenuContent = ['Logout', 'Settings'];
final _adminController = Get.put(AdminController());
Widget buildAppbar() => SliverAppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      expandedHeight: 200,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/img/admin.jpg',
          fit: BoxFit.cover,
        ),
        collapseMode: CollapseMode.pin,
        title: Text('Admin Panel'),
        centerTitle: true,
      ),
      // title: Text('Admin Panel'),
      // leading: Icon(Icons.arrow_back),
      actions: [
        PopupMenuButton(
            onSelected: (result) {
              if (result == 'Logout') {
                globals.auth.signOut();
                _adminController.updateIndex(0);
                Get.offNamed('/auth');
              } else if (result == 'Settings') {
                // FirebaseFirestore.instance.collection(collectionPath)
              }
            },
            icon: Icon(Icons.settings),
            itemBuilder: ((BuildContext context) {
              return _popupMenuContent.map((content) {
                return PopupMenuItem(
                  value: content,
                  child: Text(content),
                );
              }).toList();
            })),
        SizedBox(width: 12)
      ],
    );
