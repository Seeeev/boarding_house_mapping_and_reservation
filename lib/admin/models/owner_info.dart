class OwnerInfo {
  String uid;

  String ownerName;
  String bldgName;
  String address;
  double lat;
  double lng;
  String content;
  String roomCount;

  OwnerInfo(this.uid, this.ownerName, this.bldgName, this.address, this.lat,
      this.lng, this.content, this.roomCount);

  getMap() {
    return {
      'uid': uid,
      'ownerName': ownerName,
      'bldgName': bldgName,
      'address': address,
      'lat': lat,
      'lng': lng,
      'content': content,
      'roomCount': roomCount,
    };
  }
}
