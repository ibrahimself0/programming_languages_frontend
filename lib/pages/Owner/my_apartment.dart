// import 'dart:convert';
// import 'dart:ffi';

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
    Provider.of<ApartmentProvider>(context, listen: false)
        .fetchMyApartments();
  });
}
  
  // Future<void> delete1Apartment(int id) async {
  //   final token = await getToken();
  //   final url = Uri.parse(
  //     "http://192.168.137.36:8000/api/owner/apartments/$id",
  //   );

  //   final response = await http.delete(
  //     url,
  //     headers: {'Authorization': 'Bearer $token', 'Accept': 'application/jFson'},
  //   );

  //   if (response.statusCode == 200) {
  //     if (!mounted) return;

  //     Provider.of<ApartmentProvider>(
  //       context,
  //       listen: false,
  //     ).removeApartment(id);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Apartment deleted successfully")),
  //     );
  //   } else {
  //     print("Failed to delete apartment: ${response.statusCode}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApartmentProvider>(context);
    final myApartments = provider.myApartments;

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
                    return Padding(  padding: const EdgeInsets.symmetric(vertical: 5),child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: AppColors.cyan,borderRadius: BorderRadius.circular(20)),
                      width: double.infinity,
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.home,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                          Column(
                            children: [
                              Text(
                                "${apt.country} - ${apt.province}",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              Text(
                                "Rooms: ${apt.rooms}   Price: ${apt.price}",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              
                              
                            ],
                          ),
                          
                          Column(
                                children: [
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
                                              builder: (_) =>
                                                  EditApartmentScreen(
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
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.cyan,
                            title: Text(
                              "Warning",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            content: Text(
                              "Are You Sure?",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),actions: [TextButton(onPressed: (){deleteApartment(context, apt.id);}, child: Text("yes"))]
                          );
                                        },);
                                        }
                                      ),
                                    ],
                                  ),
                                ],)
                        ],
                      ),
                      
                    ));

                  
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
    final url = Uri.parse(
      "http://$ip:8000/api/owner/apartments/$id",
    );

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
