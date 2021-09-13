import 'dart:async';

import 'package:boarding_house_mapping_v2/constants/tenant_constants.dart';
import 'package:boarding_house_mapping_v2/tenant/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

final CameraPosition _parsu = CameraPosition(
  target: LatLng(13.697392705935073, 123.48250838055424),
  zoom: 17.4746,
);
final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414);

final String uid = Get.arguments[0];
final String screenName = Get.arguments[1];

var markerId = ownerInfo[0]['markerId'] as String;
var lat = ownerInfo[0]['lat'] as double;
var lng = ownerInfo[0]['lng'] as double;

// final Marker _parsuMarker = Marker(
//   markerId: MarkerId(markerId),
//   // infoWindow: InfoWindow(title: 'parsu', snippet: 'asdnlka laksdna nasdlasd'),
//   position: LatLng(lat, lng),
//   onTap: () => bottomSheet(uid, screenName),
// );

Widget buildMap(context) {
  final Completer<GoogleMapController> _controller = Completer();

  return GoogleMap(
    mapType: MapType.hybrid,
    initialCameraPosition: _parsu,
    onMapCreated: (GoogleMapController controller) {
      _controller.complete(controller);
    },
    markers: {
      ...ownerInfo.map((e) {
        return Marker(
          markerId: MarkerId('asdasd'),
          position: LatLng(13.697392705935073, 123.48250838055424),

          // markerId: MarkerId(e['markerId']),
          // position: LatLng(e['lat'], e['lng']),
          onTap: () {
            buidBottomSheet(context);
          },
        );
      })
    },
  );
}
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Get.bottomSheet(
      //       Container(
      //         height: 100,
      //         color: Colors.greenAccent,
      //         child: Text('asdasd'),
      //       ),
      //       isDismissible: false,
      //     );
      //   },
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),


  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

