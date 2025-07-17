import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final data = userDoc.data();

        setState(() {
          name = data['fullName'];
          email = userEmail;
          phone = data['phone'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Failed to load user data: $e");
    }
  }

  Future<void> _editPhoneNumber() async {
    final controller = TextEditingController(text: phone ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Phone Number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: '+233 55 000 0000'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newPhone = controller.text.trim();
              final userEmail = FirebaseAuth.instance.currentUser?.email;
              if (userEmail != null && newPhone.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userEmail)
                    .update({'phone': newPhone});

                setState(() {
                  phone = newPhone;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildField({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PickupHistoryPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationsPage()));
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage(WMA_profiles.Profile_default),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.edit,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// NAME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildField(
                        title: 'Name',
                        child: Text(
                          name ?? 'Loading...',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  /// EMAIL
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildField(
                        title: 'Email',
                        child: Text(
                          email ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                    SizedBox(height: 5,),
                  Container(
                          width: ScreenSize.screenWidth(context),
                          child: Text("Your email would be used as a means to contact you about orders, news and other important information concerning your account.", style: TextStyle(
                            color: Colors.grey
                          ),),
                        ),

                  /// PHONE
                  _buildField(
                    title: 'Phone number (Optional)',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            phone!.isEmpty ? "Not Available" :phone ?? 'Loading.......',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black54),
                              onPressed: _editPhoneNumber,
                            ),
                          ],
                        ),

                        Container(
                          width: ScreenSize.screenWidth(context),
                          child: Text("Your phone number would be used to contact you during deliveries, for enquiries or to deliver urgent information.", style: TextStyle(
                            color: Colors.grey
                          ),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

      /// Bottom Nav Bar
    
    );
  }
}
