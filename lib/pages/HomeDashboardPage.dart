import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';

import 'package:waste_mangement_app/pages/pages_Ext.dart'; 

class Homedashboardpage extends StatefulWidget {
  const Homedashboardpage({super.key});

  @override
  State<Homedashboardpage> createState() => _HomedashboardpageState();
}

class _HomedashboardpageState extends State<Homedashboardpage> {

  String? _firstName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }


   Future<void> _loadUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final email = currentUser.email;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final fullName = querySnapshot.docs.first['fullName'];
        final firstName = _getFirstName(fullName);
        setState(() {
          _firstName = firstName;
        });
      }
    } catch (e) {
      print("Error loading user name: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getFirstName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isLoading  ?CircularProgressIndicator() : greetingSection(_firstName==null? "Name Not Available"  :    _firstName != null  ?"Hi $_firstName"  : 'Loading...........', WMA_profiles.Profile_default),
              const SizedBox(height: 20),
              nextPickupCard(context),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Waste collectors near you', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> WasteCollectorsPage()));
                    },
                    child: const Row(
                      children: [
                        Text('See more'),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  )
                ],
              ),
              collectorsList(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent pickups', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>PickupHistoryPage()));
                    },
                    child: const Row(
                      children: [
                        Text('See all'),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  )
                ],
              ),
              recentPickupList(),
              const SizedBox(height: 80),
              
      
            ],
          ),
        ),
      ),
    );
  }
}