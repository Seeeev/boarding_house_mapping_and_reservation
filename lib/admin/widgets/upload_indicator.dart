import 'package:flutter/material.dart';

Widget uploadingIndicator() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Uploading Info...'),
        SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
            width: 15,
            height: 15)
      ],
    ),
  );
}

Widget uploadCompleteInicator() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Upload complete!'),
        SizedBox(
            child: Icon(Icons.check, color: Colors.green),
            width: 15,
            height: 15)
      ],
    ),
  );
}
