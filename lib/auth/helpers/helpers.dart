import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;

Future<String?>? authUserSignUp(LoginData data) async {
  try {
    if (data.name.contains('_admin@') || data.name.contains('_owner@')) {
      return 'Invalid email format';
    }
    await globals.auth.createUserWithEmailAndPassword(
        email: data.name, password: data.password);

    globals.currentRoute = '/tenant';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else if (e.code == 'unknown') {
      return 'Empty field(s)';
    } else if (e.code == 'invalid-email') {
      return 'Invalid email format';
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
  }
}

Future<String?>? authUser(LoginData data) {
  print('Name: ${data.name}, Password: ${data.password}');
  return Future.delayed(globals.loginTime).then((_) async {
    try {
      await globals.auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      print('valid');
      if (globals.auth.currentUser != null) {
        // data.name.contains('_admin@')
        //     ? Get.toNamed('/admin', parameters: {
        //         'email': globals.auth.currentUser?.email as String,
        //         'uid': globals.auth.currentUser!.uid
        //       })
        //     : data.name.contains('_owner@')
        //         ? Get.toNamed('/chat', parameters: {
        //             'email': globals.auth.currentUser?.email as String,
        //             'uid': globals.auth.currentUser!.uid
        //           })
        // : Get.toNamed('/tenant', parameters: {
        //     'email': globals.auth.currentUser?.email as String,
        //     'uid': globals.auth.currentUser!.uid
        //   });

        data.name.contains('_admin@')
            ? globals.currentRoute = '/admin'
            : data.name.contains('_owner@')
                ? globals.currentRoute = '/chat/owner'
                : globals.currentRoute = '/tenant';
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'wrong-password') {
        return 'The password provided is incorrect.';
      } else if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'network-request-failed') {
        return 'Please connect to the internet.';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  });
}
