import 'package:app/constants/app_colors.dart';
import 'package:app/constants/url.dart';
import 'package:app/data/notifiers.dart';
import 'package:app/models/api_response.dart';
import 'package:app/pages/Tenant/add_booking_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/general_service.dart';
import '../../services/tenant_service.dart';

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

String? selectedProvince;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> filters = {};
  late ApiResponse apiResponse;
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
      apiResponse = await getApartments(await getToken());
    } else {
      apiResponse = await getApartmentsFiltered(await getToken(), filters);
    }
    if (apiResponse.error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text(apiResponse.error.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        apartmentsNotifier.value = (apiResponse.data as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        isLoadingNotifier.value = false;
      });
    }
  }

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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.cyan,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.cyan,
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => _ProvinceBottomSheet(
                          onSelect: (value) {
                            setState(() {
                              selectedProvince = value;
                              filters["province"] = selectedProvince;
                              sendApartmentsReq(filters);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedProvince ?? 'Select province',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    _filterIcon(
                      icon: Icons.bedroom_parent_rounded,
                      tooltip: "Rooms",
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => StatefulBuilder(
                            builder: (context, setModalState) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 8),

                    _filterIcon(
                      icon: Icons.attach_money,
                      tooltip: "Price",
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => StatefulBuilder(
                            builder: (context, setModalState) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      onChanged: (values) => setModalState(
                                        () => priceRange = values,
                                      ),
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
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 8),

                    _filterIcon(
                      icon: Icons.refresh,
                      tooltip: "Reset",
                      onTap: () {
                        isLoadingNotifier.value = true;
                        sendApartmentsReq({});
                        setState(() {
                          isLoadingNotifier.value = false;
                          selectedProvince = "Select Province";
                          filters = {};
                        });
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: apartmentsNotifier,
                  builder: (context, value, child) {
                    if (apartmentsNotifier.value.isNotEmpty) {
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
                          //final apt = apartmentsNotifier.value[index];

                          final images = apartment['images'] ?? [];
                          final imageUrl = images.isNotEmpty
                              ? "${images[0]['url']}/${images[0]['image_path']}"
                              : "https://via.placeholder.com/150"; // fallback
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ApartmentViewDetails(
                                    specapartment: apartment,
                                  ),
                                ),
                              );
                            },
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.95, end: 1),
                              duration: const Duration(milliseconds: 300),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Card(
                                elevation: 6,
                                shadowColor: AppColors.cyan,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: AppColors.cyan,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: AppColors.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:
                                            apartment['images'] != null &&
                                                apartment['images'].isNotEmpty
                                            ? Image.network(
                                                "${apartment['images'][0]['url']}/${apartment['images'][0]['image_path']}",
                                                width: double.infinity,
                                                height: 130,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                height: 130,
                                                color: Colors.grey.shade300,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        apartment['province'],
                                        style: TextStyle(
                                          color: AppColors.cyan,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${apartment['price']}",
                                        style: TextStyle(
                                          color: AppColors.cyan,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "${apartment['rooms']} rooms",
                                        style: TextStyle(
                                          color: AppColors.cyan,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: AppColors.cyan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apartment,
                              size: 80,
                              color: AppColors.cyan,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No apartments match your filters",
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Try adjusting your filters or refresh the list.",
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.statusCode == 201
              ? "Added to favorites"
              : "Something went wrong",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.cyan,
        title: const Text("Apartment Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: specapartment['images'].length,
              controller: PageController(viewportFraction: 0.9),
              itemBuilder: (context, index) {
                final imageUrl =
                    "${specapartment['images'][index]['url']}/${specapartment['images'][index]['image_path']}";

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: MaterialButton(
                      height: 48,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: AppColors.cyan,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddBookingPage(apartment: specapartment),
                          ),
                        );
                      },
                      child: Text(
                        "Rental Request",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MaterialButton(
                    height: 48,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: AppColors.cyan,
                    onPressed: () =>
                        addToFavorites(context, specapartment['id']),
                    child: Icon(
                      Icons.favorite_border,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _infoCard("Province", specapartment['province']),
                    _infoCard("Price", "\$${specapartment['price']}"),
                    _infoCard("Rooms", specapartment['rooms'].toString()),
                    _infoCard("Description", specapartment['description']),

                    /*ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: 5,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, index) => ListTile(
                        title: Text(rate[index] as String),
                        onTap: () {
                          selectedRate = 1 as String;
                        },
                      ),
                    ),*/

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, v, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - v)),
          child: Opacity(opacity: v, child: child),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: AppColors.cyan,
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.cyan, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: AppColors.cyan, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                    Text(
                      title,
                      style: TextStyle(color: AppColors.cyan, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _filterIcon({
  required IconData icon,
  required VoidCallback onTap,
  String? tooltip,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.cyan),
    ),
  );
}
