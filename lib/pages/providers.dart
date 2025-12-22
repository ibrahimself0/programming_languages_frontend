import 'package:flutter/material.dart';

class Apartment {
  final String title;
  final String description;
  final double price;

  Apartment({
    required this.title,
    required this.description,
    required this.price,
  });
}

class ApartmentProvider extends ChangeNotifier {
  final List<Apartment> _apartments = [];

  List<Apartment> get apartments => _apartments;

  void addApartment(Apartment apartment) {
    _apartments.add(apartment);
    notifyListeners(); 
  }
}