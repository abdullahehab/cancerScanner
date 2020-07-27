import 'dart:convert';


import 'package:http/http.dart' as http;

class APIS {
  String text = '';
  var OCR_URL = 'https://skin-cancer-detector-api.herokuapp.com/predict';
  var translateAPI =
      'https://translation.googleapis.com/language/translate/v2?key=AIzaSyDat1jys70j1ZbZl4MyD3oeRg1WQpT-9rU';

  Future fetchSetting(String image) async {
    print('calling api');

    var response = await http.post(OCR_URL,
        body: {"image": image}, encoding: Encoding.getByName("utf-8"));

    return response;
  }

  Future translate(String text) async {
    final http.Response response = await http.post(
      translateAPI,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "q": text,
        "source": "en",
        "target": "Ar",
        "format": "text"
      }),
    );

    return response;
  }
}
