import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart'; 
import 'package:waste_mangement_app/pages/pages_Ext.dart'; 

class Homedashboardpage extends StatefulWidget {
  const Homedashboardpage({super.key});

  @override
  State<Homedashboardpage> createState() => _HomedashboardpageState();
}

class _HomedashboardpageState extends State<Homedashboardpage> {


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
              greetingSection('Fafa', WMA_profiles.Profile_1),
              const SizedBox(height: 20),
              nextPickupCard(context),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Waste collectors near you', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () {},
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
                    onPressed: () {},
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