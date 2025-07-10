import 'package:flutter/material.dart';

import 'package:waste_mangement_app/pages/pages_Ext.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';


class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homedashboardpage(),
    const MyWastePage(),
    Center(child: Text('Profile')),
    Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Only show on index 0 & 1
    final bool showPickupButton = _selectedIndex == 0;
    final bool showASButton = _selectedIndex == 1;

    return Scaffold(
      body: _pages[_selectedIndex],

      // (1) Add bottomSheet for the pickup button
      bottomSheet: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          // slide from bottom
          final offsetAnim = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(position: offsetAnim, child: child);
        },
        child: showPickupButton || showASButton
            ? Padding(
                // key ensures AnimatedSwitcher knows this is a new widget
                key: const ValueKey('request_button'),
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
                child: 
                showASButton ?
                AddScheduleButton((){
                  showAddScheduleModal(context);
                })
              
                : requestPickupButton(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RequestPickupScreen(),
                    ),
                  );
                })
              )
            : const SizedBox(
                // empty container when hidden
                key: ValueKey('empty_space'),
                height: 0,
              ),
      ),
      // (2) Standard BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'My Waste'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
