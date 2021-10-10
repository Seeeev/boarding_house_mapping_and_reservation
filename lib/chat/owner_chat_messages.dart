import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:boarding_house_mapping_v2/globals/gobals.dart' as globals;
import 'package:get/get.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: '${globals.auth.currentUser!.displayName}',
    uid: globals.auth.currentUser!.uid,
    // avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  List<ChatMessage> messages = <ChatMessage>[];
  var m = <ChatMessage>[];

  var i = 0;

  String tenantId = Get.parameters['tenantId']!;
  String displayName = Get.parameters['displayName']!;

// used in random key genarator for sending code to tenants
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

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
        .collection(tenantId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(message.toJson());
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void _sendTicket() {
    ChatMessage message = ChatMessage(
      user: user,
      text: """
      Hi $displayName your ticket # is ${getRandomString(10)}
      Use this as a verification code.""",
      createdAt: DateTime.now(),
    );
    FirebaseFirestore.instance
        .collection('messages')
        .doc(globals.auth.currentUser!.uid)
        .collection(tenantId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(message.toJson());
  }

  StreamBuilder<QuerySnapshot> _showChatMessage() {
    return StreamBuilder<QuerySnapshot>(
        // stream: FirebaseFirestore.instance
        //     .collection(
        //         Get.parameters['ownerUid']! + globals.auth.currentUser!.uid)
        //     .orderBy("createdAt")
        //     .snapshots(),
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(globals.auth.currentUser!.uid)
            .collection(
                tenantId) // if no tenant is chatting the owner return an empty collection(randomCollection)
            .orderBy("createdAt")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
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
                          .doc(globals.auth.currentUser!.uid)
                          .collection(tenantId)
                          .add(message.toJson());
                    }
                  },
                )
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        actions: [
          InkWell(
            child: Center(child: Text('Send Code')),
            onTap: () => _sendTicket(),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: _showChatMessage(),
    );
  }
}
