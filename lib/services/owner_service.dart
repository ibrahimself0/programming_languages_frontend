import 'dart:convert';

import 'package:app/models/api_response.dart';
import 'package:app/services/general_service.dart';
import 'package:http/http.dart' as http;

import '../constants/url.dart';

Future<ApiResponse> getApartmentReservations(int aptID) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();
  final response = await http.get(
    Uri.parse("$baseUrl/owner/apartment/reservations/$aptID"),
    headers: {
      "Accept": "application/json",
      if (token.isNotEmpty)
        "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    apiResponse.data = data;
    return apiResponse;
  }

  final error = jsonDecode(response.body);
  throw Exception(error["message"]);
}
Future<ApiResponse> handlePendingReservation(
    int reservationId,
    String action,
    ) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    print("handling");
    final token = await getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/owner/reservations/pending/$reservationId"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "action": action,
      }),
    );

    final data = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      apiResponse.data = data;
      print(apiResponse.data);
    } else {
      apiResponse.error = data["message"] ?? "Something went wrong";
    }
  } catch (e) {
    apiResponse.error = "Server error";
  }

  return apiResponse;
}

