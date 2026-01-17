import 'dart:convert';

import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/pages/providers.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditableImageList extends StatefulWidget {
  final List<dynamic>? images;
  final Function(int) onDelete;

  const EditableImageList({
    super.key,
    required this.images,
    required this.onDelete,
  });

  @override
  State<EditableImageList> createState() => _EditableImageListState();
}

class _EditableImageListState extends State<EditableImageList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images?.length,
        itemBuilder: (context, index) {
          final String url = "http://$ip:8000/storage";
          var img = widget.images?[index];
          String imgUrl;

          if (img is String) {
            imgUrl = img;
          } else if (img is Map<String, dynamic>) {
            imgUrl = "$url/${img['image_path']}";
          } else {
            imgUrl = ""; // fallback
          }
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.images!.length > 1) {
                      setState(() {
                        selectedIndex = isSelected ? null : index;
                      });
                    }else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Can't delete all photos")));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imgUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      color: isSelected ? Colors.black : null,
                      colorBlendMode: isSelected
                          ? BlendMode.darken
                          : BlendMode.srcOver,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        widget.onDelete(index);
                        setState(() {
                          selectedIndex = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
        "images":widget.apartment.images
      }),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final updatedApartment = Apartment.fromJson(data["apartment"]);

      if (!mounted) return;

      Provider.of<ApartmentProvider>(
        context,
        listen: false,
      ).updateApartment(updatedApartment);

      Navigator.pop(context);
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.cyan),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Edit Apartment",
          style: TextStyle(color: AppColors.cyan),
        ),
      ),
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
                hintText: "country",
              ),
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
                hintText: "province",
              ),
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
                hintText: "descirption",
              ),
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
                hintText: "Number of rooms",
              ),
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
                hintText: "Price",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8,),
            EditableImageList(
              images: widget.apartment.images,
              onDelete: (index) {
                setState(() {
                  widget.apartment.images?.removeAt(index);
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyan,
                foregroundColor: AppColors.primaryColor,
              ),
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
