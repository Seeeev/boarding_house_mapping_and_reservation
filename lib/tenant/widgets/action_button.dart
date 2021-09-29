import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;

final _popupMenuContent = ['Logout', 'Settings'];

Widget actionButton() {
  return PopupMenuButton(
    onSelected: (result) {
      print(result);

      if (result == "Logout") {
        globals.auth.signOut();
        Get.offNamed('/auth');
      } else
        print(globals.auth.currentUser!.uid);
    },
    icon: Icon(Icons.settings),
    itemBuilder: ((BuildContext context) {
      return _popupMenuContent.map((content) {
        return PopupMenuItem(
          value: content,
          child: Text(content),
        );
      }).toList();
    }),
  );
}
