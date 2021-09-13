import 'package:boarding_house_mapping_v2/globals/gobals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;

import 'auth_theme.dart';
import 'helpers/helpers.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class AuthScreen extends StatelessWidget {
  // final  FirebaseAuth? auth = FirebaseAuth.instance;

  // Duration get loginTime => Duration(milliseconds: 2250);

  // Future<String?>? authUser(LoginData data) {
  //   print('Name: ${data.name}, Password: ${data.password}');
  //   return Future.delayed(loginTime).then((_) {
  //     if (!users.containsKey(data.name)) {
  //       return 'User not exists';
  //     }
  //     if (users[data.name] != data.password) {
  //       return 'Password does not match';
  //     }
  //     return null;
  //   });
  // }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        logo: 'assets/logo/logo.png',
        title: '      Goa Boarding House\nMap and Information System',
        theme: authTheme(),
        onSignup: authUserSignUp,
        onLogin: authUser,
        onSubmitAnimationCompleted: () =>
            Get.offNamed(globals.currentRoute, parameters: {
              'email': globals.auth.currentUser?.email as String,
              'uid': globals.auth.currentUser!.uid,
            }),
        onRecoverPassword: _recoverPassword);
  }
}
