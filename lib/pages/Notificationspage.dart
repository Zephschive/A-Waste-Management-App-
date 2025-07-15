import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'message': 'Your waste collector, Jack Obeng has arrived.',
      'time': '7:21',
      'avatarUrl': WMA_profiles.Profile_2, // Replace with your actual image
      'isUnread': true,
    },
    {
      'message': 'Your waste collector, Jack Obeng has arrived.',
      'time': '7:21',
      'avatarUrl': WMA_profiles.Profile_3,
      'isUnread': false,
    },
    {
      'message': 'Your waste collector, Jack Obeng has arrived.',
      'time': '7:21',
      'avatarUrl': WMA_profiles.Profile_4,
      'isUnread': false,
    },
    {
      'message': 'Your waste collector, Jack Obeng has arrived.',
      'time': '7:21',
      'avatarUrl': WMA_profiles.Profile_5,
      'isUnread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(item['avatarUrl']),
                radius: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['message'],
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item['time'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (item['isUnread'])
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.circle, color: Colors.green, size: 10),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
