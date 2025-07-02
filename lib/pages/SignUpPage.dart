import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false, // prevents layout shift on keyboard
    body: Stack(
      children: [
        // Background image locked in place
        Positioned.fill(
          child: Image.asset(
            WMA_Images.GreenDumpster_Background,
            fit: BoxFit.cover,
          ),
        ),

        // Black gradient overlay at bottom
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Main content with blur
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Blurred container for form
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              dropdownColor: Colors.black87,
                              hint: const Text(
                                'Select waste company',
                                style: TextStyle(color: Colors.white70),
                              ),
                              iconEnabledColor: Colors.white70,
                              items: ['Zoomlion', 'Jekora', 'Asadu Waste']
                                  .map((company) => DropdownMenuItem(
                                        value: company,
                                        child: Text(
                                          company,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle selection
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(hint: 'Enter your email'),
                          const SizedBox(height: 16),
                          _buildTextField(
                              hint: 'Create a password', isPassword: true),
                          const SizedBox(height: 16),
                          _buildTextField(
                              hint: 'Confirm password', isPassword: true),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade900,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Sign up',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: RichText(
                              text: const TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(color: Colors.white70),
                                children: [
                                  TextSpan(
                                    text: "Sign in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: const [
                              Expanded(
                                  child: Divider(
                                      color: Colors.white24, thickness: 1)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("or",
                                    style: TextStyle(color: Colors.white70)),
                              ),
                              Expanded(
                                  child: Divider(
                                      color: Colors.white24, thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildAuthButton(
                              icon: Icons.g_mobiledata,
                              label: 'Continue with Google'),
                          const SizedBox(height: 16),
                          _buildAuthButton(
                              icon: Icons.apple, label: 'Continue with Apple'),
                          const SizedBox(height: 24),
                          const Text(
                            "By signing up, you are confirming that you have read, "
                            "and agree with all our Terms and Conditions.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white54),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_off, color: Colors.white70)
              : null,
        ),
      ),
    );
  }

  Widget _buildAuthButton({required IconData icon, required String label}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
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
}
