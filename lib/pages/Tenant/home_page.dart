import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/models/api_response.dart';
import 'package:flutter/material.dart';

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
      apiResponse.add(
        await getApartmentsFiltered(await getToken(), filters),
      );
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
                        return Card(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ApartmentViewDetails(),
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
  const ApartmentViewDetails({super.key});

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
                    onPressed: () {},
                    child: Text(
                      "add",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
                // Expanded(
                //   child: MaterialButton(
                //     color: AppColors.primaryColor,
                //     onPressed: () {},
                //     child: Text("add", style: TextStyle(color: AppColors.cyan)),
                //   ),
                // ),
                Expanded(
                  child: MaterialButton(
                    color: AppColors.cyan,
                    onPressed: () {},
                    child: Text(
                      "Rental Request",
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
                  Text("price :", style: TextStyle(color: AppColors.cyan)),
                  Text(
                    "Description :",
                    style: TextStyle(color: AppColors.cyan),
                  ),
                  Text("Location :", style: TextStyle(color: AppColors.cyan)),
                  Text("Space :", style: TextStyle(color: AppColors.cyan)),
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

//
