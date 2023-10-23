import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';
import '../../constants.dart';
import '../../helper/helper_functions.dart';
import '../../views/signup_user_page.dart';
import '../../widgets/custom_text_field.dart';
import '../models/chats.dart';
import '../widgets/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  final String? appBarText;
  final String appBarimage;
  final String messageId;
  final int flag;

  const ChatPage({
    super.key,
    required this.appBarimage,
    required this.messageId,
    this.appBarText,
    this.flag = 0,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? text;
  late String email;
  final ScrollController _controller = ScrollController();

  File? img;
  dynamic pickedFile;

  void _scrollDown() {
    _controller.animateTo(
      0, //_controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCirc,
    );
  }

  @override
  void initState() {
    super.initState();
    // Assign the widget's email to the variable in initState
    email = widget.messageId;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference chat = chats.doc(chatId).collection('$chatId-Chat');

    return StreamBuilder<QuerySnapshot>(
      stream: chat.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        List<Chat> texts = [];

        if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            texts.add(Chat.fromJson(snapshot.data!.docs[i]));
            // print(snapshot.data!.docs[i].id);
            // print(snapshot.data!.docs[i]['text']);
          }
          // print(texts[0].text);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: true,
              leadingWidth: 30,
              centerTitle: true,
              title: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  CustomCircleAvatar(
                    image: widget.appBarimage,
                    r1: 25,
                    r2: 23,
                    borderColor: kSecondaryColor,
                    flag: widget.flag,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.appBarText ?? 'DOCTOR',
                    style: const TextStyle(
                      fontSize: 27,
                      fontFamily: 'Pacifico',
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      controller: _controller,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: texts.length,
                      itemBuilder: (context, i) {
                        return texts[i].chatId == email
                            ? ChatBubble1(message: texts[i])
                            : ChatBubble2(message: texts[i]);
                      },
                    ),
                  ),
                ),
                CustomTextFieldForChat(
                  onChanged: (data) {
                    text = data.trim();
                  },
                  onSubmitted: (data) {
                    text = data.trim();
                    if (text!.isNotEmpty) {
                      chat.add({
                        kChatId: email,
                        kText: text,
                        kCreatedAt: DateTime.now(),
                      });
                    }
                    controllerChat.clear();
                    _scrollDown();
                    text = '';
                  },
                  onPressed: () {
                    if (text!.isNotEmpty) {
                      chat.add({
                        kChatId: email,
                        kText: text,
                        kCreatedAt: DateTime.now(),
                        // kCounter: snapshot.data!.docs[snapshot.data!.docs.length]
                        //                 [kCounter] + 1,
                      });
                    }
                    controllerChat.clear(); // controller.text = '';
                    _scrollDown();
                    text = '';
                  },
                  cameraOnPressed: () async {
                    img = await pickImage(
                        imageSource: ImageSource.camera,
                        pickedFile: pickedFile);

                    setState(() {});
                  },
                  galleryOnPressed: () async {
                    img = await pickImage(
                        imageSource: ImageSource.gallery,
                        pickedFile: pickedFile);

                    setState(() {});
                  },
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: SizedBox(
                width: 40,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    _scrollDown();
                  },
                  elevation: 0,
                  splashColor: Colors.blue[900],
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  child: const Icon(
                    Icons.keyboard_double_arrow_down,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title: const Row(
                children: [
                  CustomCircleAvatar(
                    image: 'assets/icons/Medical Diagnosis System.png',
                    r1: 27,
                    r2: 25,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Chat',
                    style: TextStyle(fontSize: 25, fontFamily: 'Pacifico'),
                  ),
                ],
              ),
            ),
            body: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Loading... ',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 25,
                        fontFamily: 'Pacifico'),
                  ),
                  CircularProgressIndicator(
                      color: kPrimaryColor, backgroundColor: Colors.grey)
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
