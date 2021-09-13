import 'package:get/get.dart';

class TenantController extends GetxController {
  var isMapLoading = 1.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 5), () {
      isMapLoading.value = 0;
    });
  }
}
