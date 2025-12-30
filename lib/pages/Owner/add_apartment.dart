import 'dart:io';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OwnerAddApartmentScreen extends StatefulWidget {
  const OwnerAddApartmentScreen({super.key});

  @override
  State<OwnerAddApartmentScreen> createState() =>
      _OwnerAddApartmentScreenState();
}

class _OwnerAddApartmentScreenState extends State<OwnerAddApartmentScreen> {
  File? ApartmentImage;
  Future<void> pickApartmentImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        ApartmentImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveApartment() async {
    var uri = Uri.parse("http://192.168.137.36:8000/api/owner/apartments");
    final token = await getToken();
    var request = http.MultipartRequest('POST', uri);
    request.fields['country'] = countryController.text;
    request.fields['province'] = provinceController.text;
    request.fields['description'] = descController.text;
    request.fields['rooms'] = roomsController.text;
    request.fields['price'] = priceController.text;

    if (ApartmentImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', ApartmentImage!.path),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print(response.body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      final apartment = Apartment.fromJson(data['apartment']);
      if (!mounted) return;

      Provider.of<ApartmentProvider>(
        context,
        listen: false,
      ).addApartment(apartment);


      print("Apartment saved successfully");
      Navigator.pop(context);

    } else {
      print("Failed to save apartment: ${response.statusCode}");
    }
  }

  final countryController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final roomsController = TextEditingController();
  final provinceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.cyan),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: const Text(
          'add apartment',
          style: TextStyle(color: AppColors.cyan),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: provinceController,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.room, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "province",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: countryController,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.money, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "country",
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: roomsController,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.home_outlined, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "Number Of Rooms",
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: priceController,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.euro, color: AppColors.cyan),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "price",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descController,
              style: TextStyle(color: AppColors.cyan),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.cyan,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: TextStyle(color: AppColors.cyan),
                hintText: "description",
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                pickApartmentImage();
              },
              color: AppColors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: Text(
                "ApartmentImage",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan,foregroundColor: AppColors.primaryColor),
              onPressed: () {
                saveApartment();

                // Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
