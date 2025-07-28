import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Auth = FirebaseAuth.instance;
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Account',
            tiles: [
              _buildTile(
                icon: Icons.person_outline,
                text: 'Account management',
                onTap: () {
                  showSnackbar("Functionaltiy not available at the moment", Colors.red, Colors.white, context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Content',
            tiles: [
              _buildTile(
                icon: Icons.notifications_outlined,
                text: 'Push notifications',
                onTap: () {
                      showSnackbar("Functionaltiy not available at the moment", Colors.red, Colors.white, context);
                },
              ),
              _buildTile(
                icon: Icons.language,
                text: 'Language',
                onTap: () {
                      showSnackbar("Functionaltiy not available at the moment", Colors.red, Colors.white, context);
                },
              ),
              _buildTile(
                icon: Icons.accessibility_new,
                text: 'Accessibility',
                onTap: () {
                      showSnackbar("Functionaltiy not available at the moment", Colors.red, Colors.white, context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Support',
            tiles: [
              _buildTile(
                icon: Icons.report_problem_outlined,
                text: 'Report a problem',
                onTap: () {
                      showSnackbar("Functionaltiy not available at the moment", Colors.red, Colors.white, context);
                },
              ),
              _buildTile(
                icon: Icons.help_outline,
                text: 'Help',
                onTap: () {
                      showSnackbar("Functionaltiy not available at the moment", Colors.red, Colors.white, context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: '',
            tiles: [
              _buildTile(
                icon: Icons.logout,
                text: 'Log out',
                onTap: () {
               setState(() {
                  isLoading = true;
                 });
               try{

                
                Auth.signOut();
                showSnackbar("Signout Successful", Colors.green, Colors.white, durationSeconds: 2, context);

                Future.delayed(Duration(seconds: 2));
                Navigator.push(context, MaterialPageRoute(builder: (_)=> SignInScreen()));

               }catch(e){

               }
                },
              ),
            ],
          ),
        ],
      ),
     
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> tiles,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ...tiles,
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
