import 'package:flutter/material.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;
import 'package:get/get.dart';

final _popupMenuContent = ['Logout', 'Settings'];

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
              print(result);
              if (result == 'Logout') {
                globals.auth.signOut();
                Get.toNamed('/auth');
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
