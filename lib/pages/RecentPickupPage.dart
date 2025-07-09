import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';

class PickupHistoryPage extends StatefulWidget {
  @override
  State<PickupHistoryPage> createState() => _PickupHistoryPageState();
}

class _PickupHistoryPageState extends State<PickupHistoryPage> {
  final List<Map<String, dynamic>> mockPickupData = [
    {
      'name': 'Joseph Amatey',
      'date': '22nd August, 2023',
      'time': '10:00 am',
      'amount': 'GHS 24.00',
      'image': WMA_profiles.Profile_2,
    },
    {
      'name': 'Larry Clue',
      'date': '22nd August, 2023',
      'time': '10:00 am',
      'amount': 'GHS 24.00',
      'image': WMA_profiles.Profile_3,
    },
    {
      'name': 'Daniel David',
      'date': '22nd August, 2023',
      'time': '10:00 am',
      'amount': 'GHS 24.00',
      'image':WMA_profiles.Profile_4,
    },
    {
      'name': 'Kelvin Adams',
      'date': '22nd August, 2023',
      'time': '10:00 am',
      'amount': 'GHS 24.00',
      'image': WMA_profiles.Profile_5,
    },
  ];

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockPickupData.length,
        itemBuilder: (context, index) {
          final pickup = mockPickupData[index];
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
                          pickup['date'],
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
                          pickup['time'],
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
                          backgroundImage: AssetImage(pickup['image']),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pickup['name'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      pickup['amount'],
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 16),
                    )
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
