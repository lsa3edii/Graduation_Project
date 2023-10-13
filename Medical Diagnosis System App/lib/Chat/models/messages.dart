import '../../../constants.dart';

class Message {
  final String messageId;
  final String text;
  // final String date;

  Message(this.messageId, this.text);

  factory Message.fromJson(jsonData) {
    return Message(jsonData[kMessageId], jsonData[kText]);
  }
}
