import 'package:app/models/api_response.dart';
import 'package:flutter/material.dart';
import 'package:app/services/owner_service.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../data/notifiers.dart';
import '../providers.dart';

class ReservationCard extends StatefulWidget {
  final Map<String, dynamic> reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  @override
  Widget build(BuildContext context) {
    final bool isAccepted = widget.reservation['status'] == 'approved';
    return AnimatedBuilder(
      animation: Listenable.merge([pending, accepted]),
      builder: (context, child) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.cyan, width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: AppColors.cyan, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Apartment Id #${widget.reservation['apartment_id']}",
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isAccepted
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.reservation['status'],
                                style: TextStyle(
                                  color: isAccepted
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              size: 16,
                              color: AppColors.cyan,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${widget.reservation['start_date']} → ${widget.reservation['end_date']}",
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: AppColors.cyan,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.reservation['total_price'],
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (!isAccepted) SizedBox(height: 16),

                        if (!isAccepted)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.cyan,
                                    side: BorderSide(color: AppColors.cyan),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await handlePendingReservation(
                                      widget.reservation['id'],
                                      'reject',
                                    );

                                    setState(() {
                                      pending.value.remove(widget.reservation);
                                      widget.reservation["status"] = "rejected";
                                    });
                                  },

                                  child: const Text("Reject"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.cyan,
                                    foregroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    ApiResponse apiResponse =
                                        await handlePendingReservation(
                                          widget.reservation['id'],
                                          'accept',
                                        );
                                    if (apiResponse.error == null) {
                                      setState(() {
                                        pending.value.remove(
                                          widget.reservation,
                                        );
                                        widget.reservation["status"] =
                                            "approved";
                                        accepted.value.add(widget.reservation);
                                      });
                                    } else {
                                      await handlePendingReservation(
                                        widget.reservation['id'],
                                        'reject',
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "error: ${apiResponse.error}",
                                          ),
                                        ),
                                      );
                                    }
                                  },

                                  child: const Text("Accept"),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
/*Widget reservationCard(Map<String, dynamic> reservation) {

}*/

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Map<String, dynamic>> reservations = [];

  Future<void> fetchReservations() async {
    isLoadingNotifier.value = true;

    final provider = Provider.of<ApartmentProvider>(context, listen: false);
    final apartments = provider.myApartments;

    reservations.clear();

    for (final apt in apartments) {
      final response = await getApartmentReservations(apt.id);
      if (response.error == null) {
        final data = response.data as Map<String, dynamic>;
        print(data);
        final list = List<Map<String, dynamic>>.from(data['reservations']);
        reservations.addAll(list);
      }
    }

    setState(() {
      pending.value = reservations
          .where((r) => r['status'] == 'pending')
          .toList();
      accepted.value = reservations
          .where((r) => r['status'] == 'approved')
          .toList();
    });

    isLoadingNotifier.value = false;
  }

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                bottom: TabBar(
                  indicatorColor: AppColors.cyan,
                  indicatorWeight: 3,
                  labelColor: AppColors.cyan,
                  unselectedLabelColor: AppColors.cyan,
                  tabs: const [
                    Tab(text: "Pending"),
                    Tab(text: "Accepted"),
                  ],
                ),
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.cyan),
                  );
                }

                return TabBarView(
                  children: [
                    buildList(pending, "No pending reservations"),
                    buildList(accepted, "No accepted reservations"),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildList(
    ValueNotifier<List<Map<String, dynamic>>> list,
    String text,
  ) {
    return ValueListenableBuilder(
      valueListenable: list,
      builder: (context, value, child) {
        if (list.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_empty, size: 60, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  text,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: list.value.length,
          itemBuilder: (context, index) {
            return ReservationCard(reservation: list.value[index]);
          },
        );
      },
    );
  }
}
