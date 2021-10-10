import 'package:boarding_house_mapping_v2/controllers/tenant_controllers.dart';
import 'package:boarding_house_mapping_v2/tenant/widgets/appbar.dart';
import 'package:boarding_house_mapping_v2/tenant/widgets/drawer.dart';
import 'package:boarding_house_mapping_v2/tenant/widgets/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TenantView extends StatelessWidget {
  final args = Get.parameters; // can have 'email' 'uid'
  final tenantController = Get.put(TenantController());

  @override
  Widget build(BuildContext context) {
    print('current route tenant');
    return Scaffold(
      drawer: buidDrawer(),
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      // body: tenantController.isMapLoading.value == 1
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : buildMap(context),
      body: buildMap(context),
    );
  }
}
