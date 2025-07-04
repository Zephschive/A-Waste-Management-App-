import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';


Widget greetingSection(String name, String imagePath) {
  return Row(
    children: [
      CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath), backgroundColor: Colors.transparent,),
      const SizedBox(width: 10),
      Text('Hi $name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    ],
  );
}

  Widget sectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

Widget nextPickupCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SchedulePage()), // ← Create this screen
      // );
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
          const Text('Your next pickup', style: TextStyle(color: Colors.white)),
          const Text(
            '22nd August, 2023',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Your current waste collector', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 5),
          const Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(WMA_profiles.Profile_2),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 10),
              Text('Joseph Amatey', style: TextStyle(color: Colors.white)),
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
              Icon(Icons.arrow_forward, color: Colors.white70, size: 14),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget collectorsList() {
  // You can extract this into a ListView.builder if the data is dynamic.
  return Column(
    children: const [
      CollectorTile(name: 'Jack Obeng', distance: '2.4 km', status: 'Available', stars: 4),
      CollectorTile(name: 'Robert Mawuli Senyo', distance: '1.1 km', status: 'Busy', stars: 3),
    ],
  );
}

Widget recentPickupList() {
  return ListView.builder(
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: 3,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          
          children: [
            // Left: Calendar icon and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(

                  children: [
                    SizedBox(width: 10,),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 10,),
                    Text('22nd August, 2023',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                 Row(
                   children: [
                     Icon(Icons.access_time, size: 14, color: Colors.grey),
                     SizedBox(width: 4),
                     Text('10:00 am',
                       style: TextStyle(fontSize: 12, color: Colors.grey),
                     ),
                   ],
                 ),
              ],
            ),
         

      const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(WMA_profiles.Profile_2),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 7),
                    Text('Joseph Amatey',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [Text('GHS 24.00',
                  style: TextStyle(
                  color: Colors.black45,
                    fontSize: 16,
                  ),
                )],
                )
              ],
            ),

      
          ],
        ),
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

  Widget buildGoogleButton({required String label}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(WMA_Icons.GoogleIcon, scale: 1.2,),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

    Widget buildAppleButton({ required String label}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(WMA_Icons.appleIcon, scale: 1.2,),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
