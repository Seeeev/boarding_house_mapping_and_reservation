import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;

class OwnerChatScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OwnerChatScreen> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final _popupMenuContent = ['Logout', 'Settings'];

  final ChatUser user = ChatUser(
    name: '${globals.auth.currentUser!.displayName}',
    uid: globals.auth.currentUser!.uid,
    // avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  // final ChatUser user = ChatUser(
  //   name: "Mrfatty",
  //   uid: "25649654",
  // );

  List<ChatMessage> messages = <ChatMessage>[];
  var m = <ChatMessage>[];

  var i = 0;
  List<String> tenantIds = [];
  @override
  void initState() {
    // globals.auth.signInWithEmailAndPassword(
    //     email: 'sample_owner@gmail.com', password: '11111111');

    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState!.scrollController
          ..animateTo(
            _chatViewKey
                .currentState!.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(globals.auth.currentUser!.uid)
        .collection(tenantIds[0])
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(message.toJson());

    /* setState(() {
      messages = [...messages, message];
      print(messages.length);
    });

    if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    } */
  }

  Widget _showChatList(tenantIds) {
    return ListView.builder(
        itemCount: tenantIds.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Get.toNamed('/chat/owner-messages',
                    parameters: {
                      'tenantId': tenantIds[index]['tenantId'],
                      'displayName': tenantIds[index]['displayName']
                    },
                    preventDuplicates: true);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: Text(
                            tenantIds[index]['displayName'][0],
                          ),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            tenantIds[index]['displayName'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    _recentChat(tenantIds, index)
                  ],
                ),
              ),
            ),
          );
        });
  }

  StreamBuilder _recentChat(tenantIds, index) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(globals.auth.currentUser!.uid)
          .collection(tenantIds[index]['tenantId'])
          .orderBy('createdAt')
          .limitToLast(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Text(
            snapshot.data!.docs[0]['text'],
            style: TextStyle(color: Colors.grey),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.auth.currentUser!.displayName!),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              onSelected: (result) {
                if (result == 'Logout') {
                  globals.auth.signOut();
                  Get.toNamed('/auth');
                } else if (result == 'Settings') {
                  // FirebaseFirestore.instance.collection(collectionPath)
                }
              },
              icon: Icon(Icons.settings),
              itemBuilder: ((BuildContext context) {
                return _popupMenuContent.map((content) {
                  return PopupMenuItem(
                    value: content,
                    child: Text(content),
                  );
                }).toList();
              })),
          SizedBox(width: 12)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_ids')
            .doc(globals.auth.currentUser!.uid)
            .collection('tenantId')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: Text('No one is chatting you'));

              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());

              case ConnectionState.active:
                var tenantIds = snapshot.data!.docs;
                return _showChatList(tenantIds);

              case ConnectionState.done:
                // var tenantIds = snapshot.data!.docs;
                // for (i = 0; i < tenantIds.length; i++) {
                //   var data = StreamBuilder(
                //     stream: FirebaseFirestore.instance
                //         .collection(globals.auth.currentUser!.uid)
                //         .doc(tenantIds[i]['tenantId'])
                //         .snapshots(),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasError) {
                //         print('error');
                //       }
                //       if (snapshot.connectionState == ConnectionState.waiting)
                //         print('waiting');
                //       print(snapshot.data);
                //       return Container();
                //     },
                //   );
                // }
                return _showChatList(tenantIds);
            }
          }
        },
      ),
    );
  }
}
