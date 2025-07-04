import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? selectedOrganization;
  List<String> organizationList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      final snapshot = await _firestore.collection('organizations').get();
      final names = snapshot.docs.map((doc) => doc['name'].toString()).toList();
      setState(() {
        organizationList = names;
      });
    } catch (e) {
      debugPrint('Error fetching organizations: $e');
    }
  }

  Future<void> signUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || selectedOrganization == null) {
      showSnackbar("Please fill all fields.");
      return;
    }

    if (password != confirmPassword) {
      showSnackbar("Passwords do not match.");
      return;
    }

    try {
      setState(() => isLoading = true);
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'organization': selectedOrganization,
      });

      showSnackbar("Sign up successful!");
      // Navigate to home or login
    } on FirebaseAuthException catch (e) {
      showSnackbar(e.message ?? "Sign up failed.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/your_background_image.png', // Replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 24),
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
                          children: [
                            _buildTextField(controller: _fullNameController, hint: 'Full Name'),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedOrganization,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                hintText: 'Select Organization',
                                hintStyle: const TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                              dropdownColor: Colors.black87,
                              iconEnabledColor: Colors.white,
                              items: organizationList
                                  .map((org) => DropdownMenuItem(
                                        value: org,
                                        child: Text(org, style: const TextStyle(color: Colors.white)),
                                      ))
                                  .toList(),
                              onChanged: (val) => setState(() => selectedOrganization = val),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(controller: _emailController, hint: 'Email'),
                            const SizedBox(height: 16),
                            _buildTextField(controller: _passwordController, hint: 'Password', isPassword: true),
                            const SizedBox(height: 16),
                            _buildTextField(controller: _confirmPasswordController, hint: 'Confirm Password', isPassword: true),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : signUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade900,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white54),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: Colors.white70) : null,
        ),
      ),
    );
  }
}
