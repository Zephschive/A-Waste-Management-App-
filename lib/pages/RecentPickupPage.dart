import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

class PickupHistoryPage extends StatefulWidget {
  @override
  State<PickupHistoryPage> createState() => _PickupHistoryPageState();
}

class _PickupHistoryPageState extends State<PickupHistoryPage> {
  List<Map<String, dynamic>> pickups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPickupHistory();
  }

  Future<String> _getCurrentUserDocId() async {
  final userEmail = auth.currentUser?.email;
  if (userEmail == null) throw Exception('No user logged in');

  final snapshot = await firestore
    .collection('users')
    .where('email', isEqualTo: userEmail)
    .limit(1)
    .get();

  if (snapshot.docs.isEmpty) {
    throw Exception('User document not found');
  }
  return snapshot.docs.first.id;
}

  Future<void> fetchPickupHistory() async {
    try {
       final userDocId = await _getCurrentUserDocId();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      


      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data.containsKey('pickups')) {
          setState(() {
            pickups = List<Map<String, dynamic>>.from(data['pickups']);
            isLoading = false;
          });
        } else {
          setState(() {
            pickups = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching pickups: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pickup history',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pickups.isEmpty
              ? const Center(child: Text("No pickup history found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pickups.length,
                  itemBuilder: (context, index) {
                    final pickup = pickups[index];

                    final dateTime = DateTime.tryParse(pickup['requestedAt'] ?? '');
                    final dateStr = dateTime != null
                        ? "${dateTime.day}/${dateTime.month}/${dateTime.year}"
                        : "Unknown date";
                    final timeStr = dateTime != null
                        ? TimeOfDay.fromDateTime(dateTime).format(context)
                        : "Unknown time";

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          // Top row with date and time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    timeStr,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row with profile and amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                   child: Text(pickup['collectorName'][0]),
                                    backgroundColor: WMA_Colours.greenPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    pickup['collectorName'] ?? 'Unknown Collector',
                                    style: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                "Paid via ${pickup['paymentMethod'] ?? 'Unknown'}",
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
