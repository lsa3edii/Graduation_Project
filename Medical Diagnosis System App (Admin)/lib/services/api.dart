import 'package:http/http.dart' as http;

class API {
  static const String _baseURL =
      'https://delete-user-auth-firebase.onrender.com/deleteUserAuth';

  API();

  static Future<void> deleteUserAuth({required String uid}) async {
    try {
      var response = await http.post(
        Uri.parse(_baseURL),
        body: {'uid': uid},
      );
      Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
      response.headers.addAll(headers);
    } catch (ex) {
      throw Exception('Error: $ex');
    }
  }
}
