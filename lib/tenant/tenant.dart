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
    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // // Get the collection of owner UIDs
            // CollectionReference uidRef =
            //     FirebaseFirestore.instance.collection('owners');

            // // for each owner uid(collection) get the boarding house info(document)
            // await uidRef.get().then((QuerySnapshot uidSnapshot) {
            //   uidSnapshot.docs.forEach((uidElement) async {
            //     CollectionReference ownerRef =
            //         FirebaseFirestore.instance.collection(uidElement['uid']);

            //     await ownerRef.get().then((QuerySnapshot ownerSnapshot) {
            //       ownerSnapshot.docs.forEach((ownerElement) {
            //         print(ownerElement.data());
            //         print('data');

            //       });
            //     });
            //   });
            // });

            print('done');
          },
        ),
        drawer: buidDrawer(),
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(),
        body: tenantController.isMapLoading.value == 1
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildMap(context),
      ),
    );
  }
}
