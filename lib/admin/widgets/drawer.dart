import 'package:flutter/material.dart';

Widget buildDrawer() => ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          padding: EdgeInsets.zero,
          child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Goa Boarding House',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      )),
                  Text(
                    'Map & Reservation System',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(title: Text('Manage Admins')),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(title: Text('Manage Owners')),
        ),
      ],
    );
