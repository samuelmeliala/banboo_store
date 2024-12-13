import 'package:banboo_store/models/user_model.dart';
import 'package:banboo_store/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:banboo_store/views/auth/register_page.dart';
import 'package:banboo_store/views/screens/splash_screen.dart';
import 'package:banboo_store/controller/services/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: const Text('Login'),
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
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
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
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
                    controller: pass,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                      onPressed: () async {
                        // Add validation
                        if (uname.text.isEmpty || pass.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

                        try {
                          User? user = await tryLogin(uname.text, pass.text);

                          if (user != null) {
                            // Login successful
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false,
                            );
                          } else {
                            // Login failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid username or password'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle network or other errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Or Login With',
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
                      child: Text('Google'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text(
                        "Don't have an account? Register Now",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
