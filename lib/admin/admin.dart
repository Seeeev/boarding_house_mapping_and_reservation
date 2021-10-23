// pub dev packages
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// local packages
import 'package:boarding_house_mapping_v2/admin/widgets/appbar.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/build_feedbacks.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/build_owner_list.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/drawer.dart';
import 'package:boarding_house_mapping_v2/admin/widgets/owner_form.dart';
import 'package:boarding_house_mapping_v2/controllers/admin_controller.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

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
      body: Obx(
        () => CustomScrollView(
          slivers: [
            buildAppbar(),
            _adminController.index.value == 0
                // ? buildOwnerForm(context)
                ? getForm(context)
                : _adminController.index.value == 1
                    ? BuildOwnerList()
                    : BuildFeedbacks(),
            // _buildOwnerList(),
          ],
        ),
      ),
    );
  }
}
