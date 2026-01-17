import 'dart:convert';
import 'package:app/constants/url.dart';
import 'package:app/models/api_response.dart';
import 'package:http/http.dart' as http;

import '../constants/errors.dart';
import 'general_service.dart';

Future<ApiResponse> getApartmentsFiltered(
  String token,
  Map<String, dynamic>? filters,
) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // Build URL with query parameters if filters exist
    Uri uri = Uri.parse(filterApartmentsUrl);
    if (filters != null && filters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: filters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
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
                "images": apartment["images"],
              },
            )
            .toList();
      } else {
        apiResponse.error = "Unexpected response format from server";
      }
    } else {
      apiResponse.error = "Something went wrong (${response.statusCode})";
    }
  } catch (e) {
    apiResponse.error = "Server error: ${e.toString()}";
  }

  return apiResponse;
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
                "images": apartment["images"],
              },
            )
            .toList();
        break;
      default:
        apiResponse.error = "Something went wrong (${response.statusCode})";
    }
  } catch (e) {
    apiResponse.error = "$serverError : ${e.toString()}";
  }
  return apiResponse;
}

Future<ApiResponse> cancelReservation(int id) async {
  ApiResponse apiResponse = ApiResponse();
  final token = await getToken();
  try {
    final response = await http.put(
      Uri.parse("$tenantReservationCancelUrl/$id"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);
        print(data);
        apiResponse.data = data['message'];
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
Future<ApiResponse> rateApartment(String rate,int id) async {
  ApiResponse apiResponse = ApiResponse();
  final token = await getToken();
  try {
    final response = await http.post(
      Uri.parse("$tenantRateApartmentUrl/$id"),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {"rating": rate},
    );

    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);
        print(data);
        apiResponse.data = data['message'];
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
