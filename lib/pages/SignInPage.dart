import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waste_mangement_app/Common_widgets/Color_ext.dart';
import 'package:waste_mangement_app/Common_widgets/images_and_icons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [ Color.fromARGB(31, 0, 0, 0) , Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            )
          ) ,
          child: Column(
            children: [
              SizedBox(height:50 ,),
                Container(
                  padding: EdgeInsets.only(left: 25),
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                           
                          ),
                        )],
                  ),
                ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                   color: Color.fromARGB(96, 21, 38, 45)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      const SizedBox(height: 24),
                      // Email Field
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.1),
                          suffixIcon: const Icon(Icons.visibility_off, color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          
                            backgroundColor: WMA_Colours.DarkgreenPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(color: Colors.white24),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("or", style: TextStyle(color: Colors.white70)),
                          ),
                          Expanded(
                            child: Divider(color: Colors.white24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Google Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Image.asset(WMA_Icons.GoogleIcon, height: 20), // Make sure the icon exists
                          label: const Text('Continue with Google'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Apple Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Image.asset(WMA_Icons.appleIcon, height: 20),
                          label: const Text('Continue with Apple'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Terms
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'By signing up, you are confirming that you have read,\nand agree with all our ',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
