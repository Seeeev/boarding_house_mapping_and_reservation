import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildOwnerList extends StatefulWidget {
  const BuildOwnerList({Key? key}) : super(key: key);

  @override
  _BuildOwnerListState createState() => _BuildOwnerListState();
}

class _BuildOwnerListState extends State<BuildOwnerList> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Text('Owners', style: TextStyle(color: Colors.black45)),
                Expanded(child: Container()),
                Text('Sort by', style: TextStyle(color: Colors.black45)),
              ],
            ),
          ),
          _showListofOwners()
        ],
      ),
    );
  }

  Widget _buildWidget(houseSnapshot) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 3),
      primary: false,
      padding: EdgeInsets.all(5),
      shrinkWrap: true,
      itemCount: houseSnapshot.data!.docs.length,
      itemBuilder: (context, index) => Card(
        child: InkWell(
          onLongPress: () =>
              print(houseSnapshot.data!.docs[index]['ownerName']),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      child: Text(
                        houseSnapshot.data!.docs[index]['ownerName']
                            .toString()[0],
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            houseSnapshot.data!.docs[index]['ownerName']
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(houseSnapshot.data!.docs[index]['bldgName'])
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  houseSnapshot.data!.docs[index]['address'].toString(),
                ),
                Text(houseSnapshot.data!.docs[index]['lat'].toString() +
                    " " +
                    houseSnapshot.data!.docs[index]['lng'].toString())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showListofOwners() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('boarding_houses')
            .snapshots(),
        builder: (context, houseSnapshot) {
          if (houseSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (houseSnapshot.connectionState == ConnectionState.done) {
            return _buildWidget(houseSnapshot);
          }
          if (houseSnapshot.connectionState == ConnectionState.none) {
            return Center(
                child: Text('No landlords are registered at the moment'));
          }
          if (houseSnapshot.hasData) {
            return _buildWidget(houseSnapshot);
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
