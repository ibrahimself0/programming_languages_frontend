import 'dart:convert';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/pages/providers.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class EditApartmentScreen extends StatefulWidget {
  final Apartment apartment;

  const EditApartmentScreen({super.key, required this.apartment});

  @override
  State<EditApartmentScreen> createState() => _EditApartmentScreenState();
}

class _EditApartmentScreenState extends State<EditApartmentScreen> {
  
  Future<void> updateApartment(int id) async {
  final token = await getToken();
  final url = Uri.parse("http://$ip:8000/api/owner/apartments/$id");

  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "country": countryController.text,
      "province": provinceController.text,
      "description": descController.text,
      "rooms": int.parse(roomsController.text),
      "price": double.parse(priceController.text),
    }),
  );

  print(response.body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final updatedApartment = Apartment.fromJson(data["apartment"]);

    if (!mounted) return;

    Provider.of<ApartmentProvider>(context, listen: false)
        .updateApartment(updatedApartment);

    Navigator.pop(context);
  } else {
    print("Failed: ${response.statusCode}");
  }
}
  
  final countryController = TextEditingController();
  final provinceController = TextEditingController();
  final descController = TextEditingController();
  final roomsController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    countryController.text = widget.apartment.country;
    provinceController.text = widget.apartment.province;
    descController.text = widget.apartment.description;
    roomsController.text = widget.apartment.rooms.toString();
    priceController.text = widget.apartment.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(iconTheme: IconThemeData(color: AppColors.cyan),centerTitle: true,backgroundColor: AppColors.primaryColor,title: const Text("Edit Apartment",style: TextStyle(color: AppColors.cyan),)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
           
            TextField(
              controller: countryController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.room, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: const TextStyle(color: AppColors.cyan),
                hintText: "country",),
            ),
           const SizedBox(height: 5),
            TextField(
              controller: provinceController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.room, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: const TextStyle(color: AppColors.cyan),
                hintText: "province",),
            ),
           const SizedBox(height: 5),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.room, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: const TextStyle(color: AppColors.cyan),
                hintText: "descirption",),
            ),
           const SizedBox(height: 5),
            TextField(
              controller: roomsController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.room, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: const TextStyle(color: AppColors.cyan),
                hintText: "Number of rooms",),
              keyboardType: TextInputType.number,
            ),
           const SizedBox(height: 5),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.room, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: const TextStyle(color: AppColors.cyan),
                hintText: "Price",),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan,foregroundColor: AppColors.primaryColor),
              onPressed: () {
                updateApartment(widget.apartment.id);
              },
              child: const Text("Update Apartment"),
            ),
          ],
        ),
      ),
    );
  }
}
