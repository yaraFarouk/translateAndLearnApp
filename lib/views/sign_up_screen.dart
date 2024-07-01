import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sign up text
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Let\'s Sign You Up!",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF8C00FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Email input
            Container(
              margin: const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                ),
              ),
            ),
            // password input
            Container(
              margin: const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
              ),
            ),
            // confirm password
            Container(
              margin: const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  border: InputBorder.none,
                ),
              ),
            ),
            // Sign up button
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8C00FF),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/home');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                ),
              ),
            ),

            // line
            Container(
              margin: const EdgeInsets.only(right: 60, left: 60),
              child: const Expanded(
                child: Divider(
                  color: Color(0x208C00FF),
                ),
              ),
            ),

            // already learner button
            Container(
              child: MaterialButton(
                  onPressed: () {  },
                  child: const Text(
                    'Already a learner? Sign in',
                    style: TextStyle(
                      color: Color(0xFF8C00FF),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
