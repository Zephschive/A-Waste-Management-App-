import 'package:flutter/material.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';



class PickupSuccessScreen extends StatelessWidget {
  final String collectorName;
  final String distance;
  final int rating;
  final bool isAvailable;
  final String profileImage;

  const PickupSuccessScreen({
    super.key,
    required this.collectorName,
    required this.distance,
    required this.rating,
    required this.isAvailable,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Pickup request successful!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Your waste collector is on the way to pick up your waste!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Collector info
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(backgroundImage: AssetImage(profileImage), radius: 24),
                title: Text(collectorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.orange,
                    );
                  }),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(distance, style: const TextStyle(fontSize: 12)),
                    Text(
                      isAvailable ? "Available" : "Unavailable",
                      style: TextStyle(
                        fontSize: 12,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Call and chat
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){},
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.call, color: Colors.black),
                    
                  ),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.chat, color: Colors.black),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Done button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(shape: WidgetStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BottomNavController())),
                child: const Text("Done"),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                // Navigate to pickup history
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("See pickup history", style: TextStyle(decoration: TextDecoration.underline)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
