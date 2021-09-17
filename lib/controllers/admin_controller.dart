import 'package:get/get.dart';

class AdminController extends GetxController {
  // current index of bottom nav bar
  var index = 1.obs;

  var isAuthFormEnabled = true.obs;

  var ownerName = "Owner's Full Name".obs;
  var ownerEmail = "Email Address".obs;
  var ownerPass = "Password".obs;

  var isLoading = 'none'.obs;

  var isPasswordVisible = false.obs;

  void updateIndex(i) {
    index.value = i;
  }

  void disableAuthForm() {
    isAuthFormEnabled.value = false;
  }

  void enableAuthForm() {
    isAuthFormEnabled.value = true;
  }

  void credentialsInitValue(String name, String email, String pass) {
    ownerName.value = name;
    ownerEmail.value = email;
    ownerPass.value = pass;
  }

  void passwordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void loadingValue(value) {
    isLoading.value = value;
  }
}
