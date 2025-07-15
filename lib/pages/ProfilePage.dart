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
  final userId = userDoc.id;
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black38)),
        const SizedBox(height: 5),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
        ]
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:  AssetImage(WMA_profiles.Profile_default), // replace with real image
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 18,
                        child: Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                Row() ,
                  _buildField(
                    title: 'Email',
                    child: email == null
                        ? const CircularProgressIndicator()
                        : Text(email!, style: const TextStyle(fontSize: 16)),
                  ),
                  _buildField(
                    title: 'Phone number (Optional)',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: phone == null || phone!.isEmpty
                              ? const Text('Not available', style: TextStyle(color: Colors.grey))
                              : Text(phone!, style: const TextStyle(fontSize: 16)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _editPhoneNumber,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
