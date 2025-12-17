import 'package:flutter/material.dart';
import 'start_page.dart';

import '../constants/app_colors.dart';
import '../data/notifiers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String searchQuery = "";
  String? priceFilter;
  String? sizeFilter;

  List<Map<String, dynamic>> apartments = [
    {
      "title": "Homs",
      "price": 400,
      "size": 80,
      "location": "Homs",
      "image": "assets/images/image2.webp",
    },
    {
      "title": "Hama",
      "price": 1200,
      "size": 120,
      "location": "Hama",
      "image": "assets/images/image2.webp",
    },
    {
      "title": "Aleppo",
      "price": 1600,
      "size": 150,
      "location": "Aleppo",
      "image": "assets/images/image2.webp",
    },
  ];

  List<Map<String, dynamic>> get filteredApartments {
    return apartments.where((item) {
      bool matchesSearch = item["location"].toString().toLowerCase().contains(
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

      bool matchesSize = true;
      if (sizeFilter != null) {
        if (sizeFilter == "0-100") {
          matchesSize = item["size"] <= 100;
        } else if (sizeFilter == "100-150") {
          matchesSize = item["size"] >= 100 && item["size"] <= 150;
        } else if (sizeFilter == "150+") {
          matchesSize = item["size"] > 150;
        }
      }

      return matchesSearch && matchesPrice && matchesSize;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                          sizeFilter = value;
                        });
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: "0-100",
                          child: Text("0-100"),
                        ),
                        const PopupMenuItem(
                          value: "100-150",
                          child: Text("100-150"),
                        ),
                        const PopupMenuItem(
                          value: "150+",
                          child: Text("More than 150"),
                        ),
                      ],
                    ),

                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: AppColors.cyan),
                      onSelected: (value) {},
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: "a", child: Text("1")),
                        const PopupMenuItem(value: "b", child: Text("2")),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          searchQuery = "";
                          priceFilter = null;
                          sizeFilter = null;
                        });
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
                          Image.asset(
                            apt["image"],
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                            cacheWidth: 300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${apt["location"]}",
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
                            "Space: ${apt["size"]}",
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

// Other Views
class HomeSecondaryView extends StatefulWidget {
  const HomeSecondaryView({super.key});

  @override
  State<HomeSecondaryView> createState() => _HomeSecondaryViewState();
}

class _HomeSecondaryViewState extends State<HomeSecondaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class HomeTertiaryView extends StatefulWidget {
  const HomeTertiaryView({super.key});

  @override
  State<HomeTertiaryView> createState() => _HomeTertiaryViewState();
}

class _HomeTertiaryViewState extends State<HomeTertiaryView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            // key: scaffoldkey,
            body: Column(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  child: TabBar(
                    // dividerColor: AppColors.cyan,
                    indicatorColor: AppColors.cyan,

                    tabs: [
                      Tab(text: "finished"),
                      Tab(text: "not-finished"),
                    ],
                    labelColor: AppColors.cyan,
                    unselectedLabelColor: AppColors.cyan,
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      Center(child: Text("data1")),
                      Center(child: Text("data2")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // home:
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/err.png"),
              ),
              const Text(
                "Shrek",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(flex: 5),

              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColors.primaryColor,
                        title: Text(
                          "Warning",
                          style: TextStyle(color: AppColors.cyan),
                        ),
                        content: Text(
                          "Are You Sure?",
                          style: TextStyle(color: AppColors.cyan),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const StartPage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(color: AppColors.cyan),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(color: AppColors.cyan, fontSize: 20),
                    ),
                    Icon(
                      Icons.logout_outlined,
                      color: AppColors.cyan,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//edit
