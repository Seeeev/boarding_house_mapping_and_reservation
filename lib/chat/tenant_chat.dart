import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;

class TenantChatScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TenantChatScreen> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: globals.auth.currentUser!.displayName,
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

  @override
  void initState() {
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

  Future<void> onSend(ChatMessage message) async {
    // FirebaseFirestore.instance
    //     .collection(Get.parameters['ownerUid']! + globals.auth.currentUser!.uid)
    //     .doc(DateTime.now().millisecondsSinceEpoch.toString())
    //     .set(message.toJson());
    FirebaseFirestore.instance
        .collection('messages')
        .doc(Get.parameters['ownerUid']!)
        .collection(globals.auth.currentUser!.uid)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(message.toJson());

    var hasSimilarValue = false;

    // Add a reference of Tenant ID to the database to be used by the owner to view its chat logs
    FirebaseFirestore.instance
        .collection('chat_ids')
        .doc(Get.parameters['ownerUid']!)
        .collection('tenantId')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length != 0) {
        snapshot.docs.forEach((element) {
          if (element['tenantId'] == globals.auth.currentUser!.uid) {
            hasSimilarValue = true;
            print('Tenant Id already exist');
          }
        });
      }
      if (!hasSimilarValue) {
        // this line is used by the owner to list out their chat logs based on his/her id and tenant id
        FirebaseFirestore.instance
            .collection('chat_ids')
            .doc(Get.parameters['ownerUid']!)
            .collection('tenantId')
            .add({
          'tenantId': globals.auth.currentUser!.uid,
          'displayName': globals.auth.currentUser!.displayName
        });
      }
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Get.parameters['ownerName']}"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          // stream: FirebaseFirestore.instance
          //     .collection(
          //         Get.parameters['ownerUid']! + globals.auth.currentUser!.uid)
          //     .orderBy("createdAt")
          //     .snapshots(),
          stream: FirebaseFirestore.instance
              .collection('messages')
              .doc(Get.parameters['ownerUid']!)
              .collection(globals.auth.currentUser!.uid)
              .orderBy("createdAt")
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
              List<DocumentSnapshot> items = snapshot.data!.docs;
              var messages = items
                  .map((i) =>
                      ChatMessage.fromJson(i.data()! as Map<dynamic, dynamic>))
                  .toList();
              return DashChat(
                key: _chatViewKey,
                inverted: false,
                onSend: onSend,
                sendOnEnter: true,
                textInputAction: TextInputAction.send,
                user: user,
                inputDecoration:
                    InputDecoration.collapsed(hintText: "Add message here..."),
                dateFormat: DateFormat('yyyy-MMM-dd'),
                timeFormat: DateFormat('HH:mm'),
                messages: messages,
                showUserAvatar: false,
                showAvatarForEveryMessage: false,
                scrollToBottom: false,
                onPressAvatar: (ChatUser user) {
                  print("OnPressAvatar: ${user.name}");
                },
                onLongPressAvatar: (ChatUser user) {
                  print("OnLongPressAvatar: ${user.name}");
                },
                inputMaxLines: 5,
                messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 16.0),
                inputContainerStyle: BoxDecoration(
                  border: Border.all(width: 0.0),
                  color: Colors.white,
                ),
                onQuickReply: (Reply reply) {
                  setState(() {
                    messages.add(ChatMessage(
                        text: reply.value,
                        createdAt: DateTime.now(),
                        user: user));

                    messages = [...messages];
                  });

                  Timer(Duration(milliseconds: 300), () {
                    _chatViewKey.currentState!.scrollController
                      ..animateTo(
                        _chatViewKey.currentState!.scrollController.position
                            .maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );

                    if (i == 0) {
                      systemMessage();
                      Timer(Duration(milliseconds: 600), () {
                        systemMessage();
                      });
                    } else {
                      systemMessage();
                    }
                  });
                },
                onLoadEarlier: () {
                  print("laoding...");
                },
                shouldShowLoadEarlier: false,
                showTraillingBeforeSend: true,
                trailing: <Widget>[
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () async {
                      final picker = ImagePicker();
                      PickedFile? result = await picker.getImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                        maxHeight: 400,
                        maxWidth: 400,
                      );

                      if (result != null) {
                        final Reference storageRef =
                            FirebaseStorage.instance.ref().child("chat_images");

                        final taskSnapshot = await storageRef.putFile(
                          File(result.path),
                          SettableMetadata(
                            contentType: 'image/jpg',
                          ),
                        );

                        String url = await taskSnapshot.ref.getDownloadURL();

                        ChatMessage message =
                            ChatMessage(text: "", user: user, image: url);

                        // FirebaseFirestore.instance
                        //     .collection(Get.parameters['ownerUid']! +
                        //         globals.auth.currentUser!.uid)
                        //     .add(message.toJson());
                        FirebaseFirestore.instance
                            .collection('messages')
                            .doc(Get.parameters['ownerUid']!)
                            .collection(globals.auth.currentUser!.uid)
                            .add(message.toJson());
                      }
                    },
                  )
                ],
              );
            }
          }),
    );
  }
}
