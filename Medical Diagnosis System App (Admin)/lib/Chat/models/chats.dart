import '../../../constants.dart';

class Chat {
  final String chatId;
  final String text;
  // final String date;

  Chat(this.chatId, this.text);

  factory Chat.fromJson(jsonData) {
    return Chat(jsonData[kChatId], jsonData[kText]);
  }
}
