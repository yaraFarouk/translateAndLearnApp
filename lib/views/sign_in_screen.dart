import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/cubit/register/Register_Cubit.dart';
import 'package:translate_and_learn_app/cubit/register/Register_States.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/home_view.dart';
import 'package:translate_and_learn_app/views/sign_up_screen.dart';

import '../constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool passHidden = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailLabel;
  String? passwordLabel;
  String? signInLabel;
  String? notLearnerText;

  final LocalizationService _localizationService = LocalizationService();

  @override
  void initState() {
    super.initState();
    _loadLabels();
  }

  Future<void> _loadLabels() async {
    emailLabel =
        await _localizationService.fetchFromFirestore('Email', 'Email');
    passwordLabel =
        await _localizationService.fetchFromFirestore('Password', 'Password');
    signInLabel =
        await _localizationService.fetchFromFirestore('Sign In', 'Sign In');
    notLearnerText = await _localizationService.fetchFromFirestore(
        'Not a learner? Sign up', 'Not a learner? Sign up');

    // Ensure the labels are loaded and the UI is updated
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              // App Logo
                              Image.asset(
                                'assets/images/logo.png',
                                scale: 4,
                              ),

                              // Sign in text
                              Container(
                                margin: EdgeInsets.only(top: 25.h),
                                child: FutureBuilder<String>(
                                    future: LocalizationService().fetchFromFirestore(
                                        'Already a learner? let\'s find out!',
                                        'Already a learner? let\'s find out!'),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Email input
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter a valid email';
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: emailLabel ?? '',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Password input
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Password is empty';
                          },
                          obscureText: passHidden,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: passwordLabel ?? '',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passHidden = !passHidden;
                                });
                              },
                              icon: Icon(
                                passHidden
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Sign in button
                        state is RegisterNewUserLoadingState
                            ? Container(
                                margin: EdgeInsets.only(top: 20.h),
                                child: const CupertinoActivityIndicator())
                            : Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8C00FF),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80.w, vertical: 20.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (formKey.currentState!.validate()) {
                                        cubit.loginUser(
                                          email: emailController.text
                                              .trim()
                                              .toString(),
                                          password: passwordController.text
                                              .toString(),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    signInLabel ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                        SizedBox(height: 20.h),

                        // line
                        const Divider(
                          color: Color(0x208C00FF),
                        ),

                        SizedBox(height: 10.h),

                        // Not a learner button
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              // Go to SignUpScreen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: Text(
                              notLearnerText ?? '',
                              style: const TextStyle(
                                color: Color(0xFF8C00FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, Object? state) async {
          if (state is LoginSuccessState) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasSeenWelcome', true);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  style: TextStyle(fontSize: 14.0), // Set the desired font size
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
