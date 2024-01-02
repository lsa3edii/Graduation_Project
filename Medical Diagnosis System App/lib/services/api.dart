import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static String? predictionImage;
  static String? diseaseStatusImage;
  static double accuracyImage = 0;

  static String? predictionText;
  static String? diseaseStatusText;
  static double accuracyText = 0;

  // static const String _baseURL1 =
  //     "https://braincancerapi-production.up.railway.app/predict";

  static const String _baseURL1 =
      "https://braincancerapi-production-6bdb.up.railway.app/predict";

  static const String _baseURL2 =
      "https://multi-cancer-nlp-api-production.up.railway.app/predict-text";

  // static const String _baseURL = 'http://localhost:5000/predict';
  // static const String _baseURL = 'https://brain-cancer-classification.onrender.com/predict';

  API();

  static Future<void> predictImage({required File img}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseURL1));

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

        predictionImage = jsonResponse['prediction'];
        accuracyImage = jsonResponse['accuracy'];

        if (predictionImage == 'no_tumor') {
          diseaseStatusImage = 'Healthy';
        } else {
          diseaseStatusImage = 'Sick';
        }
        // print(
        //     'Image Prediction = $predictionImage,\nImage Accuracy = $accuracyImage');
      } else {
        throw Exception(
            'API Error: ${response.statusCode},\nAPI Response: ${response.body}');
      }
    } catch (ex) {
      throw Exception('Error: $ex');
    }
  }

  static Future<void> predictText({required String text}) async {
    try {
      var response = await http.post(
        Uri.parse(_baseURL2),
        body: {'text': text},
      );
      Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
      response.headers.addAll(headers);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        predictionText = jsonResponse['prediction'];
        accuracyText = jsonResponse['accuracy'];

        if (predictionText == 'no_tumor') {
          diseaseStatusText = 'Healthy';
        } else {
          diseaseStatusText = 'Sick';
        }
        // print(
        //     'Text Prediction = $predictionText,\nText Accuracy = $accuracyText');
      } else {
        throw Exception(
            'API Error: ${response.statusCode},\nAPI Response: ${response.body}');
      }
    } catch (ex) {
      throw Exception('Error: $ex');
    }
  }
}
