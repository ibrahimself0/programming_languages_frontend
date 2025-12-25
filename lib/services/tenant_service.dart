import 'dart:convert';
import 'package:app/constants/url.dart';
import 'package:app/models/api_response.dart';
import 'package:http/http.dart' as http;



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
    }
  } catch (e) {
    apiResponse.error = "Server error: ${e.toString()}";
  }

  return apiResponse;
}