class BldgInfo {
  String address;
  String bldgName;
  String content;
  double lat;
  double lng;
  String ownerName;
  String uid;

  BldgInfo(
      {required this.address,
      required this.bldgName,
      required this.content,
      required this.lat,
      required this.lng,
      required this.ownerName,
      required this.uid});

  Map<String, dynamic> getBldgData() {
    return {
      'address': address,
      'bldgName': bldgName,
      'content': content,
      'lat': lat,
      'lng': lng,
      'ownerName': ownerName,
      'uid': uid
    };
  }
}
