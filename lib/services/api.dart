import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class API {
  static String? prediction;
  static String? diseaseStatus;
  static double accuracy = 0;

  static const String _baseURL =
      "https://braincancerapi-production.up.railway.app/predict";

  // static const String _baseURL = 'http://localhost:5000/predict';

  // static const String _baseURL =
  //     'https://brain-cancer-classification.onrender.com/predict';

  API();

  static Future<void> predictImage({required File img}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseURL));

      Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
      request.files.add(http.MultipartFile(
        'image',
        img.readAsBytes().asStream(),
        img.lengthSync(),
        filename: img.path.split('/').last,
      ));
      request.headers.addAll(headers);
      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        prediction = jsonResponse['prediction'];
        accuracy = jsonResponse['accuracy'];

        if (prediction == 'no_tumor') {
          diseaseStatus = 'Healthy';
        } else {
          diseaseStatus = 'Sick';
        }
        // print('Prediction = $prediction,\nAccuracy = $accuracy');
      } else {
        throw Exception(
            'API Error: ${response.statusCode},\nAPI Response: ${response.body}');
      }
    } catch (ex) {
      throw Exception('Error: $ex');
    }
  }
}
