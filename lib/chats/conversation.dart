import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:chat_app/Functions/profile_function.dart';
import 'package:chat_app/sprites/message_bar.dart';
import 'package:chat_app/sprites/text_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String admin, name;
  const Conversation({super.key, required this.admin, required this.name});

  @override
  State<StatefulWidget> createState() {
    return _Conversation();
  }
}

class _Conversation extends State<Conversation> {
  void addData(String sender, receiver, message) {
    String documentId = sender.compareTo(receiver) > 0
        ? "$sender\_$receiver"
        : "$receiver\_$sender";
    FirebaseFirestore.instance
        .collection('users')
        .doc("messages")
        .collection(documentId)
        .add({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((DocumentReference docRef) {
      print("Message added with ID: ${docRef.id}");
    }).catchError((error) => print("Failed to add message: $error"));
  }

  final ScrollController _scrollController = ScrollController();
  void scrollToListBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String documentId = widget.admin.compareTo(widget.name) > 0
        ? "${widget.admin}\_${widget.name}"
        : "${widget.name}\_${widget.admin}";
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc('messages')
                .collection(documentId) // Provide your documentId here
                .orderBy('timestamp',
                    descending:
                        true) // Assuming you want to order messages by timestamp
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('Start Conversation..🤞'),
                );
              }
              // play the tone
              return ListView(
                controller: _scrollController,
                reverse: true, // to display the latest message at the bottom
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return GestureDetector(
                    child: TextBubble(
                        text: data['message'],
                        orientation: (data['sender'] == widget.admin)
                            ? "right"
                            : "left"),
                    onLongPress: () {
                      // Show Time
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
        MessageBar(
          onMessageSent: (message) {
            addData(widget.admin, widget.name, message);
            sendNotificationToUser(
              widget.name,
              widget.admin,
              message,
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
