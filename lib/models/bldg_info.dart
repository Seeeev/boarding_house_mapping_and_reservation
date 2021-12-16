class BldgInfo {
  String address;
  String bldgName;
  String content;
  String roomCount;
  double lat;
  double lng;
  String ownerName;
  String uid;

  BldgInfo(
      {required this.address,
      required this.bldgName,
      required this.content,
      required this.roomCount,
      required this.lat,
      required this.lng,
      required this.ownerName,
      required this.uid});

  Map<String, dynamic> getBldgData() {
    return {
      'address': address,
      'bldgName': bldgName,
      'content': content,
      'roomCount': roomCount,
      'lat': lat,
      'lng': lng,
      'ownerName': ownerName,
      'uid': uid
    };
  }
}
