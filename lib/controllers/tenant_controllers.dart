import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TenantController extends GetxController {
  var isMapLoading = 1.obs;

  var ownerInfo = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    Future.delayed(Duration(seconds: 5), () {
      isMapLoading.value = 0;
    });

    CollectionReference uidRef =
        FirebaseFirestore.instance.collection('owners');

    // for each owner uid(collection) get the boarding house info(document)
    await uidRef.get().then((QuerySnapshot uidSnapshot) {
      uidSnapshot.docs.forEach((uidElement) async {
        CollectionReference ownerRef =
            FirebaseFirestore.instance.collection(uidElement['uid']);

        await ownerRef.get().then((QuerySnapshot ownerSnapshot) {
          ownerSnapshot.docs.forEach((ownerElement) {
            ownerInfo.add(ownerElement.data());
          });
        });
      });
    });
  }
}
