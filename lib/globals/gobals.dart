library globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Duration get loginTime => Duration(milliseconds: 2250);

String currentRoute = '/auth';

Future<FirebaseApp> app =
    Firebase.initializeApp(name: 'OwnerLogin', options: Firebase.app().options);
