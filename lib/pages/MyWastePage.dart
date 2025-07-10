import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';

class MyWastePage extends StatefulWidget {
  const MyWastePage({super.key});

  @override
  State<MyWastePage> createState() => _MyWastePageState();
}

class _MyWastePageState extends State<MyWastePage> {
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
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                 boxShadow: [
      BoxShadow(
        color: Colors.black38,
        blurRadius: 15,
        offset: Offset(0, 3),
      ),
    ],
                color: const Color(0xFFFFFFFF),
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
                  Divider(),
                  const SizedBox(height: 5),
                  Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        children: [
                        Row(
                          children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey),SizedBox(width: 3,),  Text('Day',
                              style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w800)),
                          ],
                        ),
                          SizedBox(height: 8),
                          Text('Tuesday',
                              style: TextStyle(fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                      Column(
                        children: [
                         Row(
                          children: [
                             Icon(Icons.access_time, size: 16, color: Colors.grey),SizedBox(width: 3,), Text('Time',
                              style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                         ),
                          SizedBox(height: 8),
                          Text('10:00 am',
                              style: TextStyle(fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                      Column(
                        children: [
                         Row(children: [
                           Icon(Icons.repeat, size: 16, color: Colors.grey), SizedBox(width: 3,), Text('Frequency',
                              style: TextStyle(fontSize: 10, color: Colors.grey)),
                         ],),
                          SizedBox(height: 8),
                          Text('Weekly',
                              style: TextStyle(fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {},
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
            const SizedBox(height: 30),
            // Request button will go here later
          ],
        ),
      ),
  
    );
  }
}
