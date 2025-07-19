import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/Notificationspage.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

class MyWastePage extends StatefulWidget {
  const MyWastePage({super.key});

  @override
  State<MyWastePage> createState() => _MyWastePageState();
}

class _MyWastePageState extends State<MyWastePage> {


Stream<DocumentSnapshot<Map<String, dynamic>>> getUserScheduleStream() {
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  if (userEmail == null) {
    throw Exception('No user logged in');
  }

  return FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: userEmail)
      .limit(1)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs.first);
}

  


//   Future<List<Map<String, dynamic>>> fetchPickupSchedule() async {
//   final userEmail = FirebaseAuth.instance.currentUser?.email;

//   if (userEmail == null) {
//     throw Exception('No user logged in');
//   }

//   final querySnapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .where('email', isEqualTo: userEmail)
//       .limit(1)
//       .get();

//   if (querySnapshot.docs.isEmpty) {
//     throw Exception('User document not found');
//   }

//   final userDoc = querySnapshot.docs.first;
//   final data = userDoc.data();
//   final scheduleList = data['schedules'] as List<dynamic>?;

//   if (scheduleList == null) return [];

//   // Convert dynamic list to List<Map<String, dynamic>>
//   return scheduleList.cast<Map<String, dynamic>>();
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My waste',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WMA_Colours.DarkgreenPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>PickupHistoryPage()));
            },
          ),

          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> NotificationsPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your next pickup card
            Container(
              height: 170,
              decoration: BoxDecoration(
                
                image: const DecorationImage(
                  image: AssetImage(WMA_Images.YellowDump_Background), // Replace with your background image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.matrix(<double>[
  0.6, 0,   0,   0, 0, // Red – 60% intensity
  0,   0.7, 0,   0, 0, // Green – 70% intensity
  0,   0,   1.2, 0, 0, // Blue – boosted to 120%
  0,   0,   0,   1, 0, // Alpha
]),


                
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Your next pickup',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '22nd August, 2023',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Divider( color: Colors.white,  thickness:0.2 ,),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        'Your current waste collector',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const Spacer(),
                      
                    ],
                  ),
                     const SizedBox(height: 5),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage(WMA_profiles.Profile_3), // Replace with actual image
                      ),

                      Container(
                      width: 140,
                        padding: EdgeInsets.only(left: 15),
                        child: const Text(
                          'Joseph Amatey',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Pickup schedule card

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  stream: getUserScheduleStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
      return const Center(child: Text("No pickup schedule found at the moment."));
    }

    final data = snapshot.data!.data();

     final schedulesRaw = data?['schedules'];
    if (schedulesRaw == null || schedulesRaw is! List || schedulesRaw.isEmpty) {
      return const Center(child: Text("No pickup schedule found at the moment."));
    }
    
    final scheduleList = (data?['schedules'])
        ?.cast<Map<String, dynamic>>() ?? [];

    if (scheduleList == null) {
      return const Center(child: Text("No pickup schedule found at the moment."));
    }

    return  Column(
  children: scheduleList.asMap().entries.map<Widget>((entry) {
    int index = entry.key;
    Map<String, dynamic> schedule = entry.value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your pickup schedule',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: WMA_Colours.greenPrimary,
              ),
            ),
            const Divider(color: Colors.black54, thickness: 0.5),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _scheduleColumn(Icons.calendar_today, "Day", schedule['day']),
                _scheduleColumn(Icons.access_time, "Time", schedule['time']),
                _scheduleColumn(Icons.repeat, "Frequency", schedule['frequency']),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.black54, thickness: 0.5),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                showEditScheduleModal(context, schedule, index);
              },
              child: const Row(
                children: [
                  Text(
                    'Edit schedule',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black87),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }).toList(), // << Ensure this is List<Widget>
);

  },
),


//             FutureBuilder<List<Map<String, dynamic>>>(
//   future: fetchPickupSchedule(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (snapshot.hasError) {
//       return Center(child: const Text("No pickup schedule found at the moment."));
//     }

//     final scheduleList = snapshot.data ?? [];

//     if (scheduleList.isEmpty) {
//         return Center(child: const Text("No pickup schedule found at the moment."));
//     }

//     return Column(
//       children: scheduleList.map((schedule) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16.0),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 15,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//               color: const Color(0xFFFFFFFF),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Your pickup schedule',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: WMA_Colours.greenPrimary,
//                   ),
//                 ),
//                 const Divider(color: Colors.black54, thickness: 0.5),
//                 const SizedBox(height: 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _scheduleColumn(Icons.calendar_today, "Day", schedule['day']),
//                     _scheduleColumn(Icons.access_time, "Time", schedule['time']),
//                     _scheduleColumn(Icons.repeat, "Frequency", schedule['frequency']),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 const Divider(color: Colors.black54, thickness: 0.5),
//                 const SizedBox(height: 12),
//                 InkWell(
//                   onTap: () {},
//                   child: const Row(
//                     children: [
//                       Text(
//                         'Edit schedule',
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(width: 6),
//                       Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black87),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   },
// ),
            const SizedBox(height: 80),
            
          ],
        ),
      ),
  
    );
  }
}

Widget _scheduleColumn(IconData icon, String label, String value) {
  return Column(
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w800)),
        ],
      ),
      const SizedBox(height: 8),
      Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
    ],
  );
}
