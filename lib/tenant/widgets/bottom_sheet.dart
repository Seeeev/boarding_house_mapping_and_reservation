import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;

Widget _buildHeader({context, bldgName, ownerName, ownerUid}) => Container(
      margin: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bldgName, style: Theme.of(context).textTheme.headline1),
              Text(ownerName, style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.directions, color: Colors.blue)),
          IconButton(
              onPressed: () async {
                final _formKey = GlobalKey<FormBuilderState>();
                // if (globals.auth.currentUser == null) {
                //   await globals.auth.signInWithEmailAndPassword(
                //       email: 'sample2_user@gmail.com', password: '11111111');
                // }

                // drop the bottom sheet
                Get.back();
                print('${globals.auth.currentUser!.email}');
                if (globals.auth.currentUser!.displayName == null) {
                  Get.defaultDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You dont have a name yet. Please add a name first before chatting with the owner.',
                          textAlign: TextAlign.center,
                        ),
                        FormBuilder(
                          key: _formKey,
                          child: FormBuilderTextField(
                            name: 'displayName',
                            decoration: const InputDecoration(
                                labelText: 'Display Name'),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                          ),
                        ),
                      ],
                    ),
                    onCancel: () {},
                    onConfirm: () async {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.saveAndValidate()) {
                        await globals.auth.currentUser!
                            .updateDisplayName(
                                _formKey.currentState!.value['displayName'])
                            .then(
                          (value) {
                            Get.back();
                            Get.toNamed('/chat/tenant',
                                preventDuplicates: false,
                                parameters: {
                                  'ownerName': ownerName,
                                  'ownerUid': ownerUid
                                });
                          },
                        );
                      }
                    },
                  );
                } else
                  Get.toNamed('/chat/tenant',
                      preventDuplicates: false,
                      parameters: {
                        'ownerName': ownerName,
                        'ownerUid': ownerUid
                      });
              },
              icon: Icon(Icons.chat, color: Colors.blue)),
        ],
      ),
    );

dynamic _defaultPhotos() {
  return [1, 2, 3, 4, 5].map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(10)),
          child: Text(
            'text $i',
            style: TextStyle(fontSize: 16.0),
          ),
        );
      },
    );
  }).toList();
}

dynamic _withPhotos(List downloadURL) {
  return downloadURL.map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(i),
              ),
              borderRadius: BorderRadius.circular(10)),
        );
      },
    );
  }).toList();
}

Widget _buildImgSlider(List photos) => CarouselSlider(
    options: CarouselOptions(height: 200.0, enlargeCenterPage: true),
    items: photos.length == 0 ? _defaultPhotos() : _withPhotos(photos));

Future<dynamic> buidBottomSheet(context, boardingHouseDetails) async {
  // get the path to the photos using uid and docId as a path
  firebase_storage.ListResult result = await firebase_storage
      .FirebaseStorage.instance
      .ref("${boardingHouseDetails['uid']}/${boardingHouseDetails['bldgName']}")
      .listAll();

  var photos = [];
  // for every photo, add it to list as a url
  // result.items.forEach((firebase_storage.Reference ref) async {
  //   String downloadURL = await ref.getDownloadURL();
  //   photos.add(downloadURL);
  // });

  await Future.forEach(result.items, (firebase_storage.Reference ref) async {
    String downloadURL = await ref.getDownloadURL();
    photos.add(downloadURL);
  });

  return showBarModalBottomSheet(
    context: context,
    builder: (context) => Container(
        height: 400,
        // margin: EdgeInsets.all(20),
        child: ListView(
          children: [
            // Header contains the building name, owner  and icons: direction and chat
            _buildHeader(
                context: context,
                bldgName: boardingHouseDetails['bldgName'],
                ownerName: boardingHouseDetails['ownerName'],
                ownerUid: boardingHouseDetails['uid']),
            // Image slider
            _buildImgSlider(photos),
            // Info content
            Container(
              margin: EdgeInsets.all(20),
              child: Text(boardingHouseDetails['content'],
                  style: Theme.of(context).textTheme.bodyText2),
            )
          ],
        )),
  );
}
