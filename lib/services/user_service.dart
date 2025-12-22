import 'dart:convert';
import 'package:app/constants/url.dart';
import 'package:app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}
Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return  prefs.getString('token') ?? "";
}
Future<ApiResponse> login({required String number, required String password}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'accept': 'application/json'},
      body: {"phone_number": number, "password": password},
    );

    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);

        apiResponse.data = {
          "message": data['message'],
          "token": data['token'],
          "role": data['role']
        };

        await saveToken(data['token']);
        break;

      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = "Something Went Wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = "Server Error";
  }
  return apiResponse;
}

Future<ApiResponse> register({
  required String phoneNumber,
  required String password,
  required String confirmPassword,
  required String firstName,
  required String lastName,
  required String dateOfBirth,
  required String role,
}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: {
        "phone_number": phoneNumber,
        "password": password,
        "password_confirmation": confirmPassword,
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth": dateOfBirth,
        "role": role,
      },
    );

    switch (response.statusCode) {
      case 201:
        final data = jsonDecode(response.body);

        apiResponse.data = {
          "message": data['message'],
          "token": data['token'],
        };


        await saveToken(data['token']);
        break;

      case 422:
        apiResponse.error = jsonDecode(response.body)['errors'].toString();
        break;

      default:
        apiResponse.error = "Something Went Wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = "Server Error";
  }

  return apiResponse;
}
Future<bool> logout() async {
  final token = await getToken();

  final response = await http.post(
    Uri.parse(logoutUrl),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return true;
  } else {
    return false;
  }
}