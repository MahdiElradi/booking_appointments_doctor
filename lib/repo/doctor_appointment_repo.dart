import 'dart:convert';

import 'package:http/http.dart' as http;

class DoctorAppointmentRepo {
  //
  Future<String> getUser(String userName, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://masoudozel-001-site1.ktempurl.com/api/Patient/Login'));
    request.body = json.encode({"username": userName, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase ?? 'Unknown error';
    }
  }
}
