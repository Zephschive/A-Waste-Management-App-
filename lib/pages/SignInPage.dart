

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}


  bool _obscureText = true;
  bool _isLoading = false;
  bool _Keepmesignedin = true;


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 
class _SignInScreenState extends State<SignInScreen> {


   Future<void> _signIn() async {
      setState(() => _isLoading = true);
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  // ✅ Input Validation
  if (email.isEmpty) {
    showSnackbar("Please enter a valid email address", Colors.red, Colors.white, context);
      setState(() => _isLoading = false);
    return;
  }

  if (password.isEmpty) {
    showSnackbar("Password must be at least 6 characters long", Colors.red, Colors.white, context);
      setState(() => _isLoading = false);
    return;
  }



  try {
     setState(() => _isLoading = true);
  await auth.signInWithEmailAndPassword(email: email, password: password);

  // ✅ Save keepMeSignedIn value to Firestore
  final user = auth.currentUser;
  if (user != null) {

 final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();


          
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first;
      final docid = data.id;

        await firestore.collection("users").doc(docid).set(
      {
        "keepMeSignedIn": _Keepmesignedin,
      },
      SetOptions(merge: true), // This avoids overwriting existing fields
    );
    }

  
  }
  

  showSnackbar("Login Successful", Colors.green, Colors.white, context, durationSeconds: 1);

  Future.delayed(const Duration(seconds: 1), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNavController()),
    );
  });


  } on FirebaseAuthException catch (e) {
    String message = 'Sign in failed';
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password.';
    }
    showSnackbar(message, Colors.red, Colors.white, context);
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap:  () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
             height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ Color.fromARGB(31, 0, 0, 0) , Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              )
            ) ,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
            ),
                child: IntrinsicHeight(
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
                                controller: _emailController,
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
                              CustomTextField(controller: _passwordController, hint: "Enter your passoword", isPassword: true,),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(value: _Keepmesignedin, onChanged:(value) {
                                    setState(() {
                                    _Keepmesignedin = value ?? false;
                                      });
                                  },),
                                  SizedBox(width: 2,),
                                Text("Keep me signed in", style: TextStyle(color: Colors.white),)
                                  ,
                                ],
                              ),
                              SizedBox(height: 3,),
                              // Forgot Password
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen()));
                                  },
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
                                child: _isLoading?Center(child: CircularProgressIndicator(),) :ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  
                                    backgroundColor: WMA_Colours.DarkgreenPrimary,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    _signIn();
                                  },
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                )  
                              ),
                              const SizedBox(height: 16),
                              // Sign up link
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=> SignUpScreen()));  
                                },
                                child: 
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
                                  onPressed: () {
                                    showSnackbar("Functionality Unavailable at the Moment Use Alternative Method", Colors.black, Colors.white, context);
                                  },
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
                                  onPressed: () {
                                     showSnackbar("Functionality Unavailable at the Moment Use Alternative Method", Colors.black, Colors.white, context);
                                  },
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
            ),
          ),
        ),
      ),
    );
  }
}
