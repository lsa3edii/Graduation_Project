import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';
import '../../constants.dart';
import '../../widgets/custom_text_field.dart';
import '../models/messages.dart';
import '../widgets/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  final String messageId;

  const ChatPage({super.key, required this.messageId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection('${messageId}_Chat');

  String? text;
  late String email;
  final ScrollController _controller = ScrollController();

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
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        List<Message> texts = [];

        if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            texts.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          // print(texts);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: true,
              leadingWidth: 30,
              centerTitle: true,
              title: const Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  CustomCircleAvatar(
                    image: 'assets/icons/Medical Diagnosis System.png',
                    r1: 25,
                    r2: 23,
                    borderColor: kSecondaryColor,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Dr. lSa3edii',
                    style: TextStyle(
                      fontSize: 25,
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
                        return texts[i].messageId == email
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
                      messages.add({
                        kMessageId: email,
                        kText: text,
                        kCreatedAt: DateTime.now(),
                      });
                    }
                    controllerChat.clear();
                    _scrollDown();
                  },
                  onPressed: () {
                    if (text!.isNotEmpty) {
                      messages.add({
                        kMessageId: email,
                        kText: text,
                        kCreatedAt: DateTime.now(),
                        // kCounter: snapshot.data!.docs[snapshot.data!.docs.length]
                        //                 [kCounter] + 1,
                      });
                    }
                    controllerChat.clear(); // controller.text = '';
                    _scrollDown();
                  },
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 55),
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
