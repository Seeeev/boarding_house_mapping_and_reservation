import 'package:boarding_house_mapping_v2/tenant/tenant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'admin/admin.dart';
import 'auth/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print('error');
            // return SomethingWentWrong();
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              theme: ThemeData(
                accentColor: Colors.black,
                textTheme: TextTheme(
                    headline1: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                        fontSize: 24)),
              ),
              debugShowCheckedModeBanner: false,
              getPages: [
                GetPage(name: '/tenant', page: () => TenantView()),
                GetPage(name: '/auth', page: () => AuthScreen()),
                // GetPage(name: '/signup', page: () => SignUpScreen()),
                GetPage(name: '/admin', page: () => AdminScreen()),
                // GetPage(name: '/owner', page: () => OwnerScreen()),
                // GetPage(name: '/chat', page: () => ChatScreen()),
              ],
              initialRoute: '/tenant',
            );
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        });
  }
}
