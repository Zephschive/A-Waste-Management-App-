import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

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
  bool isLoadingOrganizations = true;

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {

     setState(() => isLoadingOrganizations = true);
    try {
      final snapshot = await _firestore.collection('organizations').get();
      final names = snapshot.docs.map((doc) => doc['name'].toString()).toList();
      setState(() {
        organizationList = names;
      });
      setState(() => isLoadingOrganizations = false);

    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Loading Organizations")));
    }
  }

  Future<void> signUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || selectedOrganization == null) {
      showSnackbar("Please fill all fields.",Colors.red, Colors.white, context);
      return;
    }

    if (password != confirmPassword) {
      showSnackbar("Passwords do not match.", Colors.red, Colors.white, context);
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
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Signup Successful", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavController()),
      );
    });
    } on FirebaseAuthException catch (e) {
      showSnackbar(e.message ?? "Sign up failed.", Colors.red , Colors.white, context);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              WMA_Images.GreenDumpster_Background,
       // Replace with your asset path
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
                          Theme(
  data: Theme.of(context).copyWith(
    canvasColor: Colors.black87, // dropdown background
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white),
    ),
  ),
  child: DropdownButtonFormField<String>(
    value: selectedOrganization,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: isLoadingOrganizations  ?'Loading......' :'Select Organization',
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white54),
      ),
    ),
    dropdownColor: Colors.white,
    iconEnabledColor: Colors.black,

    items: organizationList
        .map((org) => DropdownMenuItem(
              value: org,
              child: Text(org, style: const TextStyle(color: Colors.black)),
            ))
        .toList(),
    onChanged: (val) => setState(() => selectedOrganization = val),
  ),
),
                            const SizedBox(height: 16),
                            _buildTextField(controller: _emailController, hint: 'Email'),
                            const SizedBox(height: 16),
                           CustomTextField(controller: _passwordController, hint: 'Password', isPassword: true),
                            const SizedBox(height: 16),
                           CustomTextField(controller: _confirmPasswordController, hint: 'Confirm password',isPassword: true, ),

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

                             const SizedBox(height: 16),
                  GestureDetector(
                    onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> SignInScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                        Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),

                   const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white38)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("or", style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(child: Divider(color: Colors.white38)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  buildGoogleButton(label: "Continue With Google", function: () {
                    showSnackbar("Functionality Unavailable at the Moment Use Alternative Method", Colors.black, Colors.white, context);
                  },),
                     const SizedBox(height: 12),

                     buildAppleButton(label: "Continue With Apple",function: () {
                       showSnackbar("Functionality Unavailable at the Moment Use Alternative Method", Colors.black, Colors.white, context);
                     },),
                      const SizedBox(height: 20),
                  Text(
                    "By signing up, you are confirming that you have read, and agree with all our Terms and Conditions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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
      textAlignVertical: TextAlignVertical.center, // Center the text vertically
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Adjust vertical padding
        suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: Colors.white70) : null,
      ),
    ),
  );
}
}
