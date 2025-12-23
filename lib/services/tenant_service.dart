import 'dart:convert';
import 'dart:io';
import 'package:app/constants/url.dart';
import 'package:app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/errors.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? "";
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

Future<ApiResponse> getApartments(String token) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse(filterApartmentsUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);
        apiResponse.data = data
            .map(
              (apartment) => {
                "id": apartment['id'],
                "owner_id": apartment['owner_id'],
                "city": apartment['city'],
                "province": apartment['province'],
                "description": apartment['description'],
                "rooms": apartment['rooms'],
                "price": apartment['price'],
                "created_at": apartment['created_at'],
                "updated_at": apartment['updated_at'],
              },
            )
            .toList();
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print(response.statusCode);
    }
  } catch (e) {
    apiResponse.error = "$serverError : ${e.toString()}";
  }
  return apiResponse;
}

Future<ApiResponse> getApartmentsFiltered(
  String token, {
  Map<String, String>? filters,
}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Build URL with query parameters if filters exist
    Uri uri = Uri.parse(filterApartmentsUrl);
    if (filters != null && filters.isNotEmpty) {
      uri = uri.replace(queryParameters: filters);
    }

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        apiResponse.data = data
            .map<Map<String, dynamic>>(
              (apartment) => {
                "id": apartment['id'],
                "owner_id": apartment['owner_id'],
                "city": apartment['city'],
                "province": apartment['province'],
                "description": apartment['description'],
                "rooms": apartment['rooms'],
                "price": apartment['price'],
                "created_at": apartment['created_at'],
                "updated_at": apartment['updated_at'],
              },
            )
            .toList();
      } else {
        apiResponse.error = "Unexpected response format from server";
      }
    } else {
      apiResponse.error = "Something went wrong (${response.statusCode})";
      print(response.body);
    }
  } catch (e) {
    apiResponse.error = "Server error: ${e.toString()}";
  }

  return apiResponse;
}
