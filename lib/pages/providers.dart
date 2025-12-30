import 'dart:convert';

import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Apartment {
  final int id;
  final String country;
  final String province;
  final String description;
  final int rooms;
  final double price;
  final String? image;

  Apartment({
    required this.id,
    required this.country,
    required this.province,
    required this.description,
    required this.rooms,
    required this.price,
    this.image,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'],
      country: json['country'],
      province: json['province'],
      description: json['description'],
      rooms: int.parse(json['rooms'].toString()),

      price:double.parse( json['price'].toString()), 
      image: json['image'],
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
  final url = Uri.parse("http://192.168.137.36:8000/api/owner/apartments");

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    myApartments = data.map((e) => Apartment.fromJson(e)).toList();
    notifyListeners();
  }
}


}
