class OwnerInfo {
  String uid;
  String ownerName;
  String bldgName;
  String address;
  double lat;
  double lng;
  String content;

  OwnerInfo(this.uid, this.ownerName, this.bldgName, this.address, this.lat,
      this.lng, this.content);

  getMap() {
    return {
      'uid': uid,
      'ownerName': ownerName,
      'bldgName': bldgName,
      'address': address,
      'lat': lat,
      'lng': lng,
      'content': content,
    };
  }
}
