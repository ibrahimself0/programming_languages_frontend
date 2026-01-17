import 'dart:convert';
import 'dart:io';

// import 'package:app/pages/providers.dart';
import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/errors.dart';
import '../constants/url.dart';
import '../models/api_response.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? "";
}

Future<void> saveId(String id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('id', id);
}

Future<int?> getIntId() async {
  final prefs = await SharedPreferences.getInstance();
  String rawId = prefs.getString('id')?.trim() ?? "";
  return int.tryParse(rawId);
}

Future<ApiResponse> login({
  required String number,
  required String password,
}) async {
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
          "role": data['role'],
        };

        await saveToken(data['token']);
        await saveRole(data['role']);
        break;

      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = "$serverError : ${e.toString()}";
  }
  return apiResponse;
}

Future<ApiResponse> register({
  required String phoneNumber,
  required String password,
  required String firstName,
  required String lastName,
  required String dateOfBirth,
  required String role,
  required File profileImage,
  required File identityImage,
}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final request = http.MultipartRequest('POST', Uri.parse(registerUrl));

    request.headers.addAll({'Accept': 'application/json'});

    request.fields['phone_number'] = phoneNumber;
    request.fields['password'] = password;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['date_of_birth'] = dateOfBirth;
    request.fields['role'] = role;

    request.files.add(
      await http.MultipartFile.fromPath('profile_image_url', profileImage.path),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'identity_image_url',
        identityImage.path,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    switch (response.statusCode) {
      case 201:
        final data = jsonDecode(response.body);

        apiResponse.data = {"message": data['message'], "token": data['token']};

        await saveToken(data['token']);
        break;

      case 422:
        apiResponse.error = jsonDecode(response.body)['errors'].toString();
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = "$serverError : ${e.toString()}";
  }

  return apiResponse;
}

Future<bool> logout() async {
  final token = await getToken();

  final response = await http.post(
    Uri.parse(logoutUrl),
    headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    return true;
  } else {
    return false;
  }
}

Future<void> saveRole(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_role', role);
}

Future<String?> getRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_role');
}

Future<ApiResponse> getProfile() async {
  ApiResponse apiResponse = ApiResponse();
  final token = await getToken();
  try {
    final response = await http.get(
      Uri.parse(profileUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);

        final profile = data['profile'];

        apiResponse.data = {
          'id': profile['id'],
          'user_id': profile['user_id'],
          'first_name': profile['first_name'],
          'last_name': profile['last_name'],
          'date_of_birth': profile['date_of_birth'],
          'profile_image':
              '${data['profile_image_url']}/${profile['profile_image_url']}',
          'identity_image':
              '${data['identity_image_url']}/${profile['identity_image_url']}',
        };
        apiResponse.error = null;
        break;

      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<ApiResponse> editProfile(String token, File? imageFile) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    var uri = Uri.parse(profileUrl);

    var request = http.MultipartRequest('PUT', uri);


    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    });

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          imageFile.path,
        ),
      );
    }

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);



    if (responseBody.statusCode == 200) {
      apiResponse.data = jsonDecode(responseBody.body);
    } else {
      apiResponse.error =
          jsonDecode(responseBody.body)['message'] ?? 'Something went wrong';
    }
  } catch (e) {
    apiResponse.error = "Server error: ${e.toString()}";
  }

  return apiResponse;
}
