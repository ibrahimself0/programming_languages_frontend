import 'dart:convert';

import 'package:app/constants/url.dart';
import 'package:app/models/api_response.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

Future<ApiResponse> login(String number, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginUrl),
        //header – tells the server what format you want back.
        headers: {'accept': 'application/json'},
        body: {"phone_number": number, "password": password});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
    }
  } catch (e) {}
  return apiResponse;
}
