import 'dart:convert';

import 'package:app/constants/url.dart';
import 'package:app/models/api_response.dart';
import 'package:app/services/general_service.dart';
import 'package:app/services/tenant_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/profile.dart';

class Apartment {
  final int id;
  final String country;
  final String province;
  final String description;
  final int rooms;
  final double price;
  List<dynamic>? images;

  Apartment({
    required this.id,
    required this.country,
    required this.province,
    required this.description,
    required this.rooms,
    required this.price,
    required this.images,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'],
      country: json['country'],
      province: json['province'],
      description: json['description'],
      rooms: int.parse(json['rooms'].toString()),

      price: double.parse(json['price'].toString()),
      images: json['images'] != null ? List<dynamic>.from(json['images']) : [],
    );
  }
}

class ApartmentProvider extends ChangeNotifier {
  final List<Apartment> _apartments = [];
  final List<Apartment> allApartments = [];
  final List<Apartment> favoriteApartments = [];
  List<Apartment> myApartments = [];

  List<Apartment> get apartments => _apartments;

  void addApartment(Apartment apartment) {
    myApartments.add(apartment);
    notifyListeners();
  }

  void removeApartment(int id) {
    myApartments.removeWhere((apt) => apt.id == id);
    notifyListeners();
  }

  void updateApartment(Apartment updated) {
    final index = myApartments.indexWhere((apt) => apt.id == updated.id);
    if (index != -1) {
      myApartments[index] = updated;
      notifyListeners();
    }
  }

  void clear() {
    myApartments = [];
    notifyListeners();
  }

  Future<void> fetchMyApartments() async {
    final token = await getToken();
    final url = Uri.parse("http://$ip:8000/api/owner/apartments");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey("message")) {
        print(" ${data["message"]}");
        return;
      }

      if (data is List) {
        myApartments = data.map((e) => Apartment.fromJson(e)).toList();
        notifyListeners();
      }
    } else {
      print("failed: ${response.statusCode}");
    }
    notifyListeners();
  }

  Future<void> fetchAllApartments() async {
    ApiResponse apiResponse = await getApartments(await getToken());
    final data = apiResponse.data;
    if (data is List) {
      myApartments = data.map((e) => Apartment.fromJson(e)).toList();
      notifyListeners();
    }
  }
}

class ProfileProvider extends ChangeNotifier {
  Profile? profile;

  Future<void> fetchProfile() async {
    final ApiResponse response = await getProfile();

    if (response.error != null || response.data == null) {
      print("API returned error or null data");
      profile = null;
      notifyListeners();
      return;
    }
    final Map<String, dynamic> profileData =
        response.data as Map<String, dynamic>? ?? {};
    //final profileData =  data["profile"];
    profile = Profile(
      id: profileData['id'] ?? 0,
      userId: profileData['user_id'] ?? 0,
      firstName: profileData['first_name'] ?? '',
      lastName: profileData['last_name'] ?? '',
      dateOfBirth: profileData['date_of_birth'] ?? '',
      profileImageUrl: profileData["profile_image"],
      identityImageUrl: profileData["identity_image"],
    );

    notifyListeners();
  }
}
