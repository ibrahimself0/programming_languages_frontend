import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/pages/Owner/update_apartment.dart';
import 'package:app/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'add_apartment.dart';
import '../providers.dart';

class MyApartments extends StatefulWidget {
  const MyApartments({super.key});

  @override
  State<MyApartments> createState() => _MyApartmentsState();
}

class _MyApartmentsState extends State<MyApartments> {
  // @override
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ApartmentProvider>(
        context,
        listen: false,
      ).fetchMyApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApartmentProvider>(context);
    final myApartments = provider.myApartments;
    final String url = "http://$ip:8000/storage";
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: myApartments.isEmpty
              ? const Center(
                  child: Text(
                    "You have no apartments yet",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: myApartments.length,
                  itemBuilder: (context, index) {
                    final apt = myApartments[index];

                    String imgUrl = "";

                    if (apt.images != null && apt.images!.isNotEmpty) {
                      final firstImage = apt.images!.first;
                      if (firstImage is Map<String, dynamic>) {
                        String path = firstImage['image_path'];
                        if (path.startsWith('images/')) {
                          path = path.replaceFirst('images/', '');
                        }
                        imgUrl = "$url/$path";
                      } else if (firstImage is String) {
                        imgUrl = firstImage;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.cyan,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: double.infinity,
                        child: Card(
                          color: AppColors.cyan,
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    apt.images != null && apt.images!.isNotEmpty
                                    ? Image.network(
                                        imgUrl,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 120,
                                        height: 120,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${apt.country} - ${apt.province}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Rooms: ${apt.rooms}   Price: ${apt.price}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColors.primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditApartmentScreen(
                                            apartment: apt,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: AppColors.cyan,
                                          title: Text(
                                            "Warning",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          content: Text(
                                            "Are You Sure?",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                deleteApartment(
                                                  context,
                                                  apt.id,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("No"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.cyan,
            child: Icon(Icons.add, color: AppColors.primaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OwnerAddApartmentScreen()),
              );
            },
          ),
        );
      },
    );
  }

  void deleteApartment(BuildContext context, int id) async {
    final token = await getToken();
    final url = Uri.parse("http://$ip:8000/api/owner/apartments/$id");

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      Provider.of<ApartmentProvider>(
        context,
        listen: false,
      ).removeApartment(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Apartment deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: ${response.statusCode}")));
    }
  }
}
