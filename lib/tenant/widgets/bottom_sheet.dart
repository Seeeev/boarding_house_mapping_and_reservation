import 'package:boarding_house_mapping_v2/constants/tenant_constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';

Widget _buildHeader({context, bldgName, ownerName}) => Container(
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
              onPressed: () {}, icon: Icon(Icons.chat, color: Colors.blue)),
        ],
      ),
    );

Widget _buildImgSlider() => CarouselSlider(
      options: CarouselOptions(height: 200.0, enlargeCenterPage: true),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'text $i',
                  style: TextStyle(fontSize: 16.0),
                ));
          },
        );
      }).toList(),
    );

Future<dynamic> buidBottomSheet(context) {
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
              bldgName: ownerInfo[0]['bldgName'],
              ownerName: ownerInfo[0]['ownerName'],
            ),
            // Image slider
            _buildImgSlider(),
            // Info content
            Container(
              margin: EdgeInsets.all(20),
              child: Text(ownerInfo[0]['content'],
                  style: Theme.of(context).textTheme.bodyText2),
            )
          ],
        )),
  );
}
