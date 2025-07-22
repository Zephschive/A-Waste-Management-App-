
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import '../pages/pages_Ext.dart';
import 'dart:math';



Widget greetingSection(String name, String imagePath) {

  Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255, // full opacity
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
  return Row(
    children: [
      CircleAvatar(radius: 30, child: Text(name[3], style: TextStyle(fontSize: 25),), backgroundColor: getRandomColor(),),
      const SizedBox(width: 10),
      Text(' $name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    ],
  );
}

  Widget sectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

Widget nextPickupCard(BuildContext context) {
  Future<Map<String, dynamic>?> _fetchNextPickup() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return null;

    // First: Get the user doc ID by querying by email
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) return null;

    final docId = userSnapshot.docs.first.id;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    if (!userDoc.exists) return null;

    final data = userDoc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> pickups =
        List<Map<String, dynamic>>.from(data['pickupss'] ?? []);

    if (pickups.isEmpty) return null;

    // Get the last pickup as the 'next pickup'
    final nextPickup = pickups.last;
    return nextPickup;
  }

  Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255, // full opacity
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}


  return FutureBuilder<Map<String, dynamic>?>(
    future: _fetchNextPickup(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final pickup = snapshot.data;

      if (pickup == null) {
        return  Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(WMA_Images.OrangeMan_Background),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            SizedBox(height: 50,),
            Center(child: Text("No upcoming pickups." ,style: TextStyle(color: Colors.white),),),
              const SizedBox(height: 10),
                SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>PickupHistoryPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'See your schedule',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward,
                        color: Colors.white70, size: 14),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      final dateTime = DateTime.tryParse(pickup['requestedAt'] ?? '');
      final dateStr = dateTime != null
          ? "${dateTime.day}/${dateTime.month}/${dateTime.year}"
          : "Unknown Date";

      final collectorName = pickup['collectorName'] ?? "Unknown";
      final collectorImage = pickup['profileImage'];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyWastePage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(WMA_Images.OrangeMan_Background),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              
              const Text('Your next pickup',
                  style: TextStyle(color: Colors.white)),
              Text(
                dateStr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Your waste collector',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 5),
              Row(
                children: [
                  CircleAvatar(
                  child: Text(collectorName[0]),
                    backgroundColor: getRandomColor(),
                  ),
                  const SizedBox(width: 10),
                  Text(collectorName,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'See your schedule',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                      color: Colors.white70, size: 14),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


Widget collectorsList() {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  if (currentUserEmail == null) {
    return const Center(child: Text("Not signed in."));
  }

  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get()
        .then((query) => query.docs.first),
    builder: (context, userSnapshot) {
      if (userSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
        return const Center(child: Text("User not found."));
      }

      final userOrg = userSnapshot.data!.data()?['organization'];
      if (userOrg == null) {
        return const Center(child: Text("No organization assigned."));
      }

      // Now that we have user's organization, fetch collectors
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('waste_collectors')
            .where('organization', isEqualTo: userOrg)
            .limit(3)
            .snapshots(),
        builder: (context, collectorSnapshot) {
          if (collectorSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!collectorSnapshot.hasData || collectorSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No collectors found for your organization."));
          }

          final collectors = collectorSnapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: collectors.length,
            itemBuilder: (context, index) {
              final data = collectors[index].data();
              final name = data['name'] ?? 'Unknown';
              final status = data['availability'] ?? 'Unknown';
              final stars = (data['rating'] ?? 0).toDouble();
              final distance = 'N/A'; // Optional: replace with real distance

              return CollectorTile(
                name: name,
                status: status,
                distance: distance,
                stars: stars.round(),
              );
            },
          );
        },
      );
    },
  );
}


Widget recentPickupList() {
  Future<String> _getCurrentUserDocId() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) throw Exception('No user logged in');

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('User document not found');
    }

    return snapshot.docs.first.id;
  }

  return FutureBuilder<String>(
    future: _getCurrentUserDocId(),
    builder: (context, idSnapshot) {
      if (idSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!idSnapshot.hasData || idSnapshot.hasError) {
        return const Center(child: Text("Failed to load recent pickups."));
      }

      final userDocId = idSnapshot.data!;

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userDocId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No recent pickups."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          List<Map<String, dynamic>> pickups =
              List<Map<String, dynamic>>.from(data['pickups'] ?? []);

          // Sort by requestedAt in descending order
          pickups.sort((a, b) {
            final aTime =
                DateTime.tryParse(a['requestedAt'] ?? '') ?? DateTime(0);
            final bTime =
                DateTime.tryParse(b['requestedAt'] ?? '') ?? DateTime(0);
            return bTime.compareTo(aTime);
          });

          final recentPickups = pickups.take(3).toList();

          if (recentPickups.isEmpty) {
            return const Center(child: Text("No recent pickups."));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentPickups.length,
            itemBuilder: (context, index) {
              final pickup = recentPickups[index];

              final dateTime =
                  DateTime.tryParse(pickup['requestedAt'] ?? '');
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                                fontWeight: FontWeight.w400,
                              ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: pickup['profileImage'] != null &&
                                      pickup['profileImage'] != ''
                                  ? NetworkImage(pickup['profileImage'])
                                  : const AssetImage(
                                      WMA_profiles.Profile_2,
                                    ) as ImageProvider,
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              pickup['collectorName'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "GHS ${pickup['amount'] ?? '0.00'}",
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}






Widget requestPickupButton(VoidCallback funct) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton(
      onPressed:funct,
      style: FilledButton.styleFrom(
        backgroundColor: WMA_Colours.greenPrimary, // Customize as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Request a pickup",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}


Widget AddScheduleButton(VoidCallback funct) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton(
      onPressed:funct,
      style: FilledButton.styleFrom(
        backgroundColor: WMA_Colours.greenPrimary, // Customize as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Add A Schedule",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}


class CollectorTile extends StatelessWidget {
  final String name;
  final String distance;
  final String status;
  final int stars;

  const CollectorTile({
    super.key,
    required this.name,
    required this.distance,
    required this.status,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundImage: AssetImage(WMA_profiles.Profile_4)),
      title: Text(name),
      subtitle: Row(
        children: List.generate(stars, (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(distance),
          Text(status, style: TextStyle(color: status == 'Available' ? Colors.green : Colors.orange)),
        ],
      ),
    );
  }
}

Widget buildCollectorCard({
  required String title,
  required String price,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
           Image.asset(WMA_Icons.TruckIcon, scale: 1 ,),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(price),
        ],
      ),
    ),
  );
}






Widget collectorTile({
  required String name,
  required String distance,
  required bool selected,
  required VoidCallback onTap,
  required String ProfileImage
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      color: selected ? Colors.green.shade100 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading:  CircleAvatar(backgroundImage: AssetImage(ProfileImage)),
        title: Text(name),
        subtitle: Row(
          children: const [
            Icon(Icons.star, size: 16, color: Colors.orange),
            Icon(Icons.star, size: 16, color: Colors.orange),
            Icon(Icons.star, size: 16, color: Colors.orange),
            Icon(Icons.star, size: 16, color: Colors.orange),
            Icon(Icons.star_border, size: 16, color: Colors.orange),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(distance, style: const TextStyle(fontSize: 12)),
            const Text("Available", style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
      ),
    ),
  );
}

  Widget buildGoogleButton({required String label,required VoidCallback function}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: function,
        icon: Image.asset(WMA_Icons.GoogleIcon, scale: 1.2,),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide( color: Colors.transparent),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

    Widget buildAppleButton({ required String label, required VoidCallback function}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed:function ,
        icon: Image.asset(WMA_Icons.appleIcon, scale: 1.2,),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.transparent),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          side: BorderSide.none
          ),
        ),
      ),
    );
  }

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white54),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        style: const TextStyle(color: Colors.white),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}



 void showSnackbar(
  String message,
  Color backgroundColor,
  Color textColor,
  BuildContext context, {
  int durationSeconds = 3, 
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationSeconds),
    ),
  );
}





Widget nextSchedulePickupCard(BuildContext context) {
  Future<Map<String, dynamic>?> _fetchScheduleNextPickup() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return null;

    // First: Get the user doc ID by querying by email
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) return null;

    final docId = userSnapshot.docs.first.id;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    if (!userDoc.exists) return null;

    final data = userDoc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> schedule =
        List<Map<String, dynamic>>.from(data['schedule'] ?? []);

    if (schedule.isEmpty) return null;

    // Get the last pickup as the 'next pickup'
    final nextPickup = schedule.last;
    return nextPickup;
  }

  Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255, // full opacity
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

   


  return FutureBuilder<Map<String, dynamic>?>(
    future: _fetchScheduleNextPickup(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final schedule = snapshot.data;

      if (schedule == null) {
        return  Container(
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
                  Center(child: Text("No Pickup Schedule found at the moment"),),
                     const SizedBox(height: 5),
                  
                ],
              ),
            );
      }

      final dateTime = DateTime.tryParse(schedule['requestedAt'] ?? '');
      final dateStr = dateTime != null
          ? "${dateTime.day}/${dateTime.month}/${dateTime.year}"
          : "Unknown Date";

      final collectorName = schedule['collectorName'] ?? "Unknown";
      final collectorImage =schedule['profileImage'];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyWastePage()),
          );
        },
        child: Container(
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
                   Text(
                    dateStr,
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
      );
    },
  );
}