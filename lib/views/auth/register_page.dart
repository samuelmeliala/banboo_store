import 'package:banboo_store/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:banboo_store/views/auth/login_page.dart';
import 'package:banboo_store/views/screens/splash_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController uname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SplashScreen()));
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 3.0),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: uname,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      fillColor: const Color(0xFFF7F8F9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE8ECF4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: const Color(0xFFF7F8F9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFE8ECF4),
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: pass,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Color(0xFFF7F8F9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE8ECF4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 318,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: const Color(0xFF686D76),
                          foregroundColor: Colors.white),
                      onPressed: () {
                        // Add validation
                        if (uname.text.isEmpty ||
                            email.text.isEmpty ||
                            pass.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

                        // Validate email format
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(email.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please enter a valid email address'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

                        // TODO: Add your registration logic here

                        // Navigate to home page and remove all previous routes
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Or Register With',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 318,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Google'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}