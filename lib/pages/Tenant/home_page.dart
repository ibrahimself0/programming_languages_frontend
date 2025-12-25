import 'package:app/constants/app_colors.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/models/api_response.dart';
import 'package:flutter/material.dart';

import '../../services/general_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String,String>filters = {
  "province":  "",
  "min_price": "",
  "max_price": "",
  "min_rooms": "",
  "max_rooms": "",
  };
  late final List<ApiResponse> apiResponse = [];
  int numberOfApiResponses = 0;
  // initializing it with an empty list cuz the getter filteredApartments can get called by build() before initApartments()
  // finishes, so Dart complains that apartments hasn’t been initialized yet
  late List<Map<String, dynamic>> apartments = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initApartments();
    });
  }

  Future<void> initApartments() async {

    apiResponse.add( await getApartments(await getToken()));

    if (apiResponse[numberOfApiResponses].error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text(apiResponse[numberOfApiResponses].error.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {

      setState(() {
        apartments = (apiResponse[numberOfApiResponses].data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
        isLoadingNotifier.value = false;

      });
    }
  }

  String searchQuery = "";
  String? priceFilter;
  String? roomsFilter;

  List<Map<String, dynamic>> get filteredApartments {
    return apartments.where((item) {
      bool matchesSearch = item["province"].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      bool matchesPrice = true;
      if (priceFilter != null) {
        if (priceFilter == "0-500") {
          matchesPrice = item["price"] >= 0 && item["price"] <= 500;
        } else if (priceFilter == "500-1000") {
          matchesPrice = item["price"] >= 500 && item["price"] <= 1000;
        } else if (priceFilter == "1000-1500") {
          matchesPrice = item["price"] >= 1000 && item["price"] <= 1500;
        } else if (priceFilter == "1500+") {
          matchesPrice = item["price"] > 1500;
        }
      }

      bool matchesRooms = true;
      if (roomsFilter != null) {
        if (roomsFilter == "1") {
          matchesRooms = item["rooms"] <= 1;
        } else if (roomsFilter == "2") {
          matchesRooms = item["1"] >= 1 && item["2"] <= 2;
        } else if (roomsFilter == "150+") {
          matchesRooms = item["3"] >= 3;
        }
      }

      return matchesSearch && matchesPrice && matchesRooms;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoadingNotifier.value){
      return ValueListenableBuilder(
        valueListenable: isLoadingNotifier,
        builder: (context, value, child) {
          return Center(child: CircularProgressIndicator(color: AppColors.cyan));
        }
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
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.filter_alt, color: AppColors.cyan),
                      onSelected: (value) {
                        setState(() {
                          priceFilter = value;
                        });
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: "0-500",
                          child: Text("0 - 500"),
                        ),
                        const PopupMenuItem(
                          value: "500-1000",
                          child: Text("500 - 1000"),
                        ),
                        const PopupMenuItem(
                          value: "1000-1500",
                          child: Text("1000 - 1500"),
                        ),
                        const PopupMenuItem(
                          value: "1500+",
                          child: Text("More Than 1500"),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.square_foot, color: AppColors.cyan),
                      onSelected: (value) {
                        setState(() {
                          roomsFilter = value;
                        });
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: "1",
                          child: Text("1"),
                        ),
                        const PopupMenuItem(
                          value: "2",
                          child: Text("2"),
                        ),
                        const PopupMenuItem(
                          value: "3+",
                          child: Text("3+"),
                        ),
                      ],
                    ),


                    IconButton(
                      onPressed: () async {
                        isLoadingNotifier.value = true;
                        final newResponse = await getApartments(await getToken());
                        apiResponse.add(newResponse);
                        final newApartments = (newResponse.data as List<dynamic>)
                            .map((e) => e as Map<String, dynamic>)
                            .toList();

                        setState(() {
                          numberOfApiResponses++;
                          apartments = newApartments;
                          isLoadingNotifier.value = false;
                        });
                        print(numberOfApiResponses);
                      },
                      icon: Icon(Icons.refresh, color: AppColors.cyan),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredApartments.length,
                  itemBuilder: (context, index) {
                    final apt = filteredApartments[index];
                    return Card(
                      color: AppColors.primaryColor,
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*Image.asset(
                            apt["image"],
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                            cacheWidth: 300,
                          ),*/
                          const SizedBox(height: 8),
                          Text(
                            "${apt["province"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.cyan,
                            ),
                          ),
                          Text(
                            "Price: \$${apt["price"]}",
                            style: TextStyle(color: AppColors.cyan),
                          ),
                          Text(
                            "Space: ${apt["rooms"]}",
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
