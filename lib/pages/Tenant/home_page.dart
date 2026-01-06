import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/models/api_response.dart';
import 'package:app/pages/Tenant/add_booking_page.dart';
import 'package:app/pages/Tenant/bookings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/general_service.dart';
import '../../services/tenant_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> filters = {};
  late final List<ApiResponse> apiResponse = [];
  int numberOfApiResponses = 0;
  // initializing it with an empty list cuz the getter filteredApartments can get called by build() before sendApartmentsReq()
  // finishes, so Dart complains that apartments hasn’t been initialized yet
  //late List<Map<String, dynamic>> apartments = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sendApartmentsReq({});
    });
  }

  Future<void> sendApartmentsReq(Map<String, dynamic>? filters) async {
    if (filters!.isEmpty) {
      apiResponse.add(await getApartments(await getToken()));
    } else {
      apiResponse.add(await getApartmentsFiltered(await getToken(), filters));
    }

    if (apiResponse[numberOfApiResponses].error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text(apiResponse[numberOfApiResponses].error.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        apartmentsNotifier.value =
            (apiResponse[numberOfApiResponses].data as List<dynamic>)
                .map((e) => e as Map<String, dynamic>)
                .toList();
        isLoadingNotifier.value = false;
      });
    }
    numberOfApiResponses++;
  }

  String searchQuery = "";
  String? priceFilter;
  RangeValues priceRange = const RangeValues(0, 2000);
  RangeValues roomsRange = const RangeValues(1, 6);
  String? countryFilter;
  @override
  Widget build(BuildContext context) {
    if (isLoadingNotifier.value) {
      return ValueListenableBuilder(
        valueListenable: isLoadingNotifier,
        builder: (context, value, child) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.cyan),
          );
        },
      );
    }
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: AppColors.cyan),
                        cursorColor: AppColors.cyan,
                        decoration: InputDecoration(
                          focusColor: AppColors.cyan,
                          fillColor: AppColors.cyan,
                          hintStyle: TextStyle(color: AppColors.cyan),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.cyan),
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.cyan),
                          ),
                          hintText: "Search...",
                          iconColor: AppColors.cyan,
                          prefixIcon: Icon(Icons.search, color: AppColors.cyan),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                            filters['province'] = searchQuery;
                            sendApartmentsReq(filters);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5),

                    PopupMenuButton<String>(
                      icon: Icon(Icons.public, color: AppColors.cyan),
                      onSelected: (value) => setState(() {
                        countryFilter = value;
                        filters['country'] = countryFilter!;
                        sendApartmentsReq(filters);
                      }),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'USA', child: Text('USA')),
                        const PopupMenuItem(
                          value: 'Syria',
                          child: Text('Syria'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: Icon(
                        Icons.bedroom_parent_rounded,
                        color: AppColors.cyan,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),

                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rooms Range",
                                        style: TextStyle(
                                          color: AppColors.cyan,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      RangeSlider(
                                        min: 1,
                                        max: 6,
                                        divisions: 5,
                                        values: roomsRange,
                                        labels: RangeLabels(
                                          "${roomsRange.start.toInt()}",
                                          "${roomsRange.end.toInt()}",
                                        ),
                                        activeColor: AppColors.cyan,
                                        inactiveColor: AppColors.darkCyan,
                                        onChanged: (values) {
                                          setModalState(() {
                                            roomsRange = values;
                                          });
                                        },
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${roomsRange.start.toInt()}",
                                            style: TextStyle(
                                              color: AppColors.cyan,
                                            ),
                                          ),
                                          Text(
                                            "${roomsRange.end.toInt()}",
                                            style: TextStyle(
                                              color: AppColors.cyan,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              filters["min_rooms"] = roomsRange
                                                  .start
                                                  .toInt();
                                              filters["max_rooms"] = roomsRange
                                                  .end
                                                  .toInt();
                                              sendApartmentsReq(filters);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Apply",
                                            style: TextStyle(
                                              color: AppColors.cyan,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.attach_money, color: AppColors.cyan),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),

                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price Range",
                                        style: TextStyle(
                                          color: AppColors.cyan,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      RangeSlider(
                                        min: 0,
                                        max: 3000,
                                        divisions: 30,
                                        values: priceRange,
                                        labels: RangeLabels(
                                          "\$${priceRange.start.toInt()}",
                                          "\$${priceRange.end.toInt()}",
                                        ),
                                        activeColor: AppColors.cyan,
                                        inactiveColor: AppColors.darkCyan,
                                        onChanged: (values) {
                                          setModalState(() {
                                            priceRange = values;
                                          });
                                        },
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${priceRange.start.toInt()}",
                                            style: TextStyle(
                                              color: AppColors.cyan,
                                            ),
                                          ),
                                          Text(
                                            "\$${priceRange.end.toInt()}",
                                            style: TextStyle(
                                              color: AppColors.cyan,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              filters["min_price"] = priceRange
                                                  .start
                                                  .toInt();
                                              filters["max_price"] = priceRange
                                                  .end
                                                  .toInt();
                                              sendApartmentsReq(filters);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Apply",
                                            style: TextStyle(
                                              color: AppColors.cyan,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),

                    IconButton(
                      onPressed: () async {
                        isLoadingNotifier.value = true;
                        sendApartmentsReq({});

                        setState(() {
                          isLoadingNotifier.value = false;
                          filters = {};
                        });
                      },
                      icon: Icon(Icons.refresh, color: AppColors.cyan),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: apartmentsNotifier,
                  builder: (context, value, child) {
                    return GridView.builder(
                      itemCount: apartmentsNotifier.value.length,

                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder: (context, index) {
                        final apartment = apartmentsNotifier.value[index];
                        final apt = apartmentsNotifier.value[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2.0,color: AppColors.cyan),
                            borderRadius: BorderRadiusGeometry.circular(10)
                          ),
                          color: AppColors.primaryColor,
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*Image.asset(
                                apartments["image"],
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                                cacheWidth: 300,
                              ),*/
                              const SizedBox(height: 5),
                              Text(
                                "${apartment["province"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cyan,
                                ),
                              ),
                              Text(
                                "Price: \$${apartment["price"]}",
                                style: TextStyle(color: AppColors.cyan),
                              ),
                              Text(
                                "Space: ${apartment["rooms"]}",
                                style: TextStyle(color: AppColors.cyan),
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  IconButton(
                                    iconSize: 18,
                                    onPressed: () {
                                      print(apt);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ApartmentViewDetails(
                                                specapartment: apt,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.info_outline_rounded,
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ApartmentViewDetails extends StatelessWidget {
  final Map<String, dynamic> specapartment;
  const ApartmentViewDetails({super.key, required this.specapartment});
  Future<void> addToFavorites(BuildContext context, int apartmentId) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse("http://$ip:8000/api/favorites/$apartmentId"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Added to favorites")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.cyan,
        title: Text(
          "ApartmentDetails",
          style: TextStyle(color: AppColors.cyan),
        ),
        centerTitle: true,

        // backgroundColor: AppColors.cyan,
      ),
      body: Column(
        children: [
          Placeholder(strokeWidth: 4, fallbackHeight: 300),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    color: AppColors.cyan,
                    onPressed: () {
                       Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => addBookingPage(apartment: specapartment)
                )
                       );
                    },
                    child: Text(
                      "Rental Request",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    color: AppColors.cyan,
                    onPressed: () async {
                      await addToFavorites(context,specapartment['id'],);
                    },

                    child: Text(
                      "add to Favorite",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                children: [
                  Text(
                    "province : ${specapartment['province']}",
                    style: TextStyle(color: AppColors.cyan),
                  ),
                  Text(
                    "price : ${specapartment['price']}",
                    style: TextStyle(color: AppColors.cyan),
                  ),
                  Text(
                    "Description : ${specapartment['description']}",
                    style: TextStyle(color: AppColors.cyan),
                  ),

                  Text(
                    "Number of Rooms : ${specapartment['rooms']}",
                    style: TextStyle(color: AppColors.cyan),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }
}
