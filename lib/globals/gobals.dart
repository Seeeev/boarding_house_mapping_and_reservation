library globals;

import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Duration get loginTime => Duration(milliseconds: 2250);

String currentRoute = '/auth';
