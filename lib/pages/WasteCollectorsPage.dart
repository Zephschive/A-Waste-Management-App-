import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WasteCollectorsPage extends StatefulWidget {
  const WasteCollectorsPage({super.key});

  @override
  State<WasteCollectorsPage> createState() => _WasteCollectorsPageState();
}

class _WasteCollectorsPageState extends State<WasteCollectorsPage> {
  late Future<List<Map<String, dynamic>>> _collectorsFuture;

  @override
  void initState() {
    super.initState();
    _collectorsFuture = _loadCollectors();
  }

  Future<List<Map<String, dynamic>>> _loadCollectors() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // Get user's organization
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (userDoc.docs.isEmpty) return [];

    final userOrg = userDoc.docs.first['organization'];

    // Query collectors by organization
    final collectorsSnapshot = await FirebaseFirestore.instance
        .collection('waste_collectors')
        .where('organization', isEqualTo: userOrg)
        .get();

    return collectorsSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round()
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildStatusText(String status) {
    Color color = status == "Available"
        ? Colors.green
        : status == "Busy"
            ? Colors.orange
            : Colors.grey;

    return Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Waste collectors near you")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _collectorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No collectors found."));
          }

          final collectors = snapshot.data!;
          return ListView.builder(
            itemCount: collectors.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final collector = collectors[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_placeholder.png'), // Replace or use NetworkImage
                  radius: 24,
                ),
                title: Text(
                  collector['name'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStarRating((collector['rating'] ?? 0).toDouble()),
                    const SizedBox(height: 4),
                    _buildStatusText(collector['availability'] ?? 'Unavailable'),
                  ],
                ),
                trailing: Text("0.2 km away"), // Mocked distance
              );
            },
          );
        },
      ),
    );
  }
}
