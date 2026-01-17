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


class _ProvinceBottomSheet extends StatelessWidget {
  final Function(String) onSelect;

  const _ProvinceBottomSheet({required this.onSelect});

  static const provinces = [
    'Damascus',
    'Aleppo',
    'Homs',
    'Hama',
    'Latakia',
    'Tartous',
    'Idlib',
    'Deir el-Zor',
    'Raqqa',
    'Hasakah',
    'Suwayda',
    'Daraa',
    'Quneitra',
    'Rif Dimashq',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provinces.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) => ListTile(
        title: Text(provinces[index]),
        onTap: () => onSelect(provinces[index]),
      ),
    );
  }
}

class OwnerAddApartmentScreen extends StatefulWidget {
  const OwnerAddApartmentScreen({super.key});

  @override
  State<OwnerAddApartmentScreen> createState() =>
      _OwnerAddApartmentScreenState();
}

class _OwnerAddApartmentScreenState extends State<OwnerAddApartmentScreen> {
  List<File>? apartmentImages = [];
   late final Apartment ?apartment;
  Future<void> pickApartmentImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 100);

    if (pickedFiles.isNotEmpty) {
      setState(() {
        apartmentImages = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> saveApartment() async {
    final token = await getToken();

    final createUri = Uri.parse("http://$ip:8000/api/owner/apartments");
    final createRequest = http.MultipartRequest('POST', createUri);
    createRequest.fields["country"] = "Syria";
    //createRequest.fields["city"] = "Damas";
    createRequest.fields['province'] = provinceController.text;
    createRequest.fields['description'] = descController.text;
    createRequest.fields['rooms'] = roomsController.text;
    createRequest.fields['price'] = priceController.text;

    createRequest.headers['Authorization'] = 'Bearer $token';
    createRequest.headers['Accept'] = 'application/json';

    final createStream = await createRequest.send();
    final createResponse = await http.Response.fromStream(createStream);

    final data = jsonDecode(createResponse.body);

    if (createResponse.statusCode == 201 && data['apartment'] != null) {
      apartment = Apartment.fromJson(data['apartment']);
    }


    if (!mounted) return;


    if (apartmentImages != null) {
      List<http.MultipartFile> imageFiles = [];

      for (var img in apartmentImages!) {
        imageFiles.add(await http.MultipartFile.fromPath('images[]', img.path));
      }
      final imageUri = Uri.parse(
        "http://$ip:8000/api/owner/apartmentsImages/${apartment?.id}",
      );

      final imageRequest = http.MultipartRequest('POST', imageUri);
      imageRequest.headers['Authorization'] = 'Bearer $token';
      imageRequest.headers['Accept'] = 'application/json';
      imageRequest.files.addAll(imageFiles);

      final imageStreamResponse = await imageRequest.send();
      final imageResponse = await http.Response.fromStream(imageStreamResponse);

      if (imageResponse.statusCode == 201) {
        final imagesResponse = await http.get(
          Uri.parse(
            "http://$ip:8000/api/owner/apartmentsImages/${apartment?.id}",
          ),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (imagesResponse.statusCode == 200) {
          final imagesData = jsonDecode(imagesResponse.body);
          apartment?.images = (imagesData['images'] as List);
        }
      }
    }
    Provider.of<ApartmentProvider>(
      context,
      listen: false,
    ).addApartment(apartment!);

    Navigator.pop(context);
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => _ProvinceBottomSheet(
                    onSelect: (value) {
                      setState(() {
                        provinceController.text = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                child: Text(
                  provinceController.text != ""
                      ? provinceController.text
                      : "Select Province",
                  style: TextStyle(color: AppColors.cyan),
                ),
              ),
              const SizedBox(height: 10),
          
              TextFormField(
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.number,
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
                onPressed: () async {
                  pickApartmentImages();
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: AppColors.primaryColor,
                ),
                onPressed: () async {
                  saveApartment();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
