import 'dart:io';

import 'package:boarding_house_mapping_v2/controllers/admin_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

final _formKey = GlobalKey<FormBuilderState>();
final _loginFormKey = GlobalKey<FormBuilderState>();
final genderOptions = ['Male', 'Female'];
final _adminController = Get.put(AdminController());
var _nameTextController = TextEditingController();
var _emailTextController = TextEditingController();
var _passTextController = TextEditingController();

FirebaseAuth _auth = FirebaseAuth.instance;

void _ownerLogin(context) {
  Get.defaultDialog(
    title: 'Login',
    textConfirm: 'Login',
    onCancel: () {},
    onConfirm: () async {
      _loginFormKey.currentState!.save();
      if (_loginFormKey.currentState!.validate()) {
        String _email = _loginFormKey.currentState!.value['email'];
        String _pass = _loginFormKey.currentState!.value['password'];
        try {
          if (!_email.contains('_owner@')) {
            _loginFormKey.currentState!.invalidateField(
                name: 'email',
                errorText: 'Email address must be of type owner');
          } else {
            await _auth.signInWithEmailAndPassword(
                email: _email, password: _pass);
            print('sign in complete');
            if (_auth.currentUser != null) {
              // _loginFormKey.currentState!.value['email']
              // _loginFormKey.currentState!.value['password']
              // print(_auth.currentUser!.displayName);
              // print(_auth.currentUser!.email as String);
              // print(_loginFormKey.currentState!.value['password']);
              _adminController.credentialsInitValue(
                  '${_auth.currentUser!.displayName}',
                  _auth.currentUser!.email as String,
                  _loginFormKey.currentState!.value['password']);

              _adminController.disableAuthForm();
              Get.back();
              _nameTextController.text = '${_auth.currentUser!.displayName}';
              _emailTextController.text = _auth.currentUser!.email as String;
              _passTextController.text =
                  _loginFormKey.currentState!.value['password'];
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            _loginFormKey.currentState!.invalidateField(
                name: 'password', errorText: 'Invalid Password');
          } else if (e.code == 'user-not-found') {
            _loginFormKey.currentState!.invalidateField(
                name: 'email',
                errorText: 'No user is associated with this email address');
          }
        }
        print(_loginFormKey.currentState!.value);

        print(_adminController.ownerEmail.value);
        print(_adminController.ownerPass.value);
      } else {
        print("validation failed");
      }
    },
    content: FormBuilder(
      key: _loginFormKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
              FormBuilderValidators.email(context)
            ]),
          ),
          Obx(
            () => FormBuilderTextField(
              name: 'password',
              obscureText: !_adminController.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    _adminController.passwordVisible();
                    print(_adminController.isPasswordVisible);
                  },
                  icon: Icon(
                    _adminController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
              ]),
            ),
          )
        ],
      ),
    ),
  );
}

Future<List<String>> _uploadPhotos(List<File> photos) async {
  List<String> _downloadUrls = [];
  await Future.forEach(photos, (File photo) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('photos')
        .child('test-uid')
        .child('test-bldgName')
        .child(basename(photo.path));
    final UploadTask uploadTask = ref.putFile(photo);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      print('photos uploaded');
    });
    final url = await taskSnapshot.ref.getDownloadURL();
    _downloadUrls.add(url);
  });

  return _downloadUrls;
}

Widget buildOwnerForm(context) {
  return SliverToBoxAdapter(
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.on,
            child: Column(
              children: <Widget>[
                Obx(
                  () => FormBuilderTextField(
                    controller: _nameTextController,
                    name: 'ownerName',
                    // valueTransformer: (value) {
                    //   if (_auth.currentUser != null) {
                    //     return _adminController.ownerName.value;
                    //   } else {
                    //     print('Email address is empty' + value!);
                    //     return value;
                    //   }
                    // },
                    enabled: _adminController.isAuthFormEnabled.value,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                    decoration: InputDecoration(labelText: "Owner's Full Name"),
                  ),
                ),
                Obx(() => FormBuilderTextField(
                      controller: _emailTextController,
                      name: 'emailAddress',
                      enabled: _adminController.isAuthFormEnabled.value,
                      // valueTransformer: (value) {
                      //   if (_auth.currentUser != null) {
                      //     // print(_auth.currentUser?.email as String);
                      //     // print('may naka login');
                      //     return _adminController.ownerEmail.value;
                      //   } else {
                      //     return value;
                      //   }
                      // },
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.email(context)
                      ]),
                      decoration: InputDecoration(labelText: 'Email Address'),
                    )),
                Obx(
                  () => FormBuilderTextField(
                    controller: _passTextController,
                    name: 'ownerPassword',
                    // valueTransformer: (value) {
                    //   if (_auth.currentUser != null) {
                    //     return _adminController.ownerPass.value;
                    //   } else {
                    //     return value;
                    //   }
                    // },
                    obscureText: !_adminController.isPasswordVisible.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    enabled: _adminController.isAuthFormEnabled.value,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.minLength(context, 8)
                    ]),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _adminController.passwordVisible();
                          print(_adminController.isPasswordVisible);
                        },
                        icon: Icon(
                          _adminController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'bldgName',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  decoration: InputDecoration(labelText: 'Building Name'),
                ),
                FormBuilderTextField(
                  name: 'address',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  decoration: InputDecoration(labelText: 'Building Address'),
                ),
                FormBuilderTextField(
                  name: 'lat',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  decoration: InputDecoration(labelText: 'Latitude'),
                ),
                FormBuilderTextField(
                  name: 'lng',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  decoration: InputDecoration(labelText: 'Longitude'),
                ),
                Container(
                  height: 300,
                  child: Card(
                    child: FormBuilderTextField(
                      name: 'content',
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Information about the business...'),
                    ),
                  ),
                ),
                FormBuilderImagePicker(
                  name: 'photos',
                  decoration: const InputDecoration(labelText: 'Pick Photos'),
                  maxImages: 10,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    child: Text('Save'),
                    onPressed: () {
                      _formKey.currentState!.save();
                      print('value on save');
                      print(_formKey.currentState!.value);
                      if (_formKey.currentState!.saveAndValidate()) {
                        if (!_formKey.currentState!.value['emailAddress']
                            .contains('_owner@')) {
                          _formKey.currentState!.invalidateField(
                              name: 'emailAddress',
                              errorText:
                                  'Email address must contain "_owner@" in order to be identified \nby the system as an owner, eg. sample_user_owner@gmail.com');
                        }
                        print('validation');
                        print(_formKey.currentState!.value);
                      }
                    }),
              ],
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    print(_formKey.currentState!.value['emailAddress']);
                    if (!_formKey.currentState!.value['emailAddress']
                        .contains('_owner@')) {
                      _formKey.currentState!.invalidateField(
                          name: 'emailAddress',
                          errorText:
                              'Email address must contain "_owner@" in order to be identified \nby the system as an owner, eg. sample_user_owner@gmail.com');
                    } else {
                      if (_formKey.currentState!.value['photos'] != null) {
                        List<File>? _imgList = [];
                        var _imgPaths = _formKey.currentState!.value['photos'];
                        for (var _path in _imgPaths) {
                          _imgList.add(_path);
                        }
                        _uploadPhotos(_imgList);
                      }
                      // try {
                      //   await _auth.createUserWithEmailAndPassword(
                      //       email: _formKey.currentState!.value['emailAddress'],
                      //       password:
                      //           _formKey.currentState!.value['ownerPassword']);
                      // } on FirebaseAuthException catch (e) {
                      //   if (e.code == 'email-already-in-use') {
                      //     Get.defaultDialog(
                      //         content: Text(
                      //             'The account already exists for that email.'));
                      //   }
                      // }
                    }
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _formKey.currentState!.reset();
                  _emailTextController.text = '';
                  _passTextController.text = '';
                  _nameTextController.text = '';
                  _auth.signOut();
                  _adminController.enableAuthForm();
                },
              ),
            ),
          ],
        ),
        InkWell(
          child: TextButton(
            onPressed: () {
              _ownerLogin(context);
            },
            style: TextButton.styleFrom(primary: Colors.black),
            child: Text('Login to an existing owner account'),
          ),
        )
      ],
    ),
  );
}
