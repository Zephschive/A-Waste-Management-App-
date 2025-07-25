import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final FirebaseAuth Auth = FirebaseAuth.instance;


   @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkIfLoggedIn();
  });
}

Future<void> _checkIfLoggedIn() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await Future.delayed(const Duration(seconds: 1)); // Optional delay

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Fetch user document
    final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();


    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      final keepMe = data["keepMeSignedIn"] ?? false;

      if (keepMe) {
        // Go to dashboard if keepMeSignedIn is true
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavController()),
        );
        return;
      }
    }

    Navigator.of(context).pop(); // Close the loading dialog
    await  Auth.signOut();
      Future.delayed(Duration(seconds: 2));
          
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  } else {
    // No user is signed in, go to SignIn screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }
}


     

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              WMA_Images.Dumptruck_Background,
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
      ),
    ),


          // Gradient at the bottom only
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),

          // Centered Texts
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left:25 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text:  TextSpan(
                      style: TextStyle(fontSize: 32, color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                          style: GoogleFonts.sofia(
                                fontWeight: FontWeight.w800
                          ),
                        ),
                        TextSpan(text: 'to the\n'),
                        TextSpan(
                          text: 'Wastecamp ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'app'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Fast and affordable waste management\nservices at your convenience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: WMA_Colours.greenPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: const Text(
                      'Create new account',
                      style: TextStyle(fontWeight: FontWeight.w700, ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SignInScreen()));
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
