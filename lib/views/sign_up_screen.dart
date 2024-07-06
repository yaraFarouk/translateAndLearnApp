import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/cubit/register/Register_Cubit.dart';
import 'package:translate_and_learn_app/cubit/register/Register_States.dart';
import 'package:translate_and_learn_app/views/home_view.dart';
import 'package:translate_and_learn_app/views/sign_in_screen.dart';

Future<String?> getSelectedLanguageString() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? nativeLanguage = prefs.getString('nativeLanguage');
  String? nativeLanguageCode = prefs.getString('nativeLanguageCode');

  if (nativeLanguage != null && nativeLanguageCode != null) {
    return '$nativeLanguage ($nativeLanguageCode)';
  } else {
    return 'No language selected';
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? selectedLanguageString;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguageString();
  }

  Future<void> _loadSelectedLanguageString() async {
    String? languageString = await getSelectedLanguageString();
    setState(() {
      selectedLanguageString = languageString;
    });
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    var passHidden = true;

    return BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);

            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sign up text
                          Container(
                            margin: EdgeInsetsDirectional.all(20.w),
                            child: const Text(
                              'Let\'s sign you up!',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w800),
                            ),
                          ),

                          // name input
                          Container(
                            margin: EdgeInsetsDirectional.all(20.w),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) return 'Enter your name';
                              },
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  label: const Text('Name'),
                                  prefixIcon:
                                      const Icon(Icons.person_outline_rounded),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.r))),
                            ),
                          ),

                          // Email input
                          Container(
                            margin: EdgeInsetsDirectional.all(20.w),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter a valid email';
                                }
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  label: const Text('Email'),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.r))),
                            ),
                          ),

                          // password input
                          Container(
                            margin: EdgeInsetsDirectional.all(20.w),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value!.isEmpty) return 'Password is empty';
                              },
                              obscureText: passHidden,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  label: const Text('Password'),
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        passHidden = !passHidden;
                                        cubit.changeVisibility();
                                      },
                                      icon: const Icon(
                                          Icons.remove_red_eye_outlined)),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.r))),
                            ),
                          ),

                          // Sign up button
                          state is RegisterNewUserLoadingState
                              ? Container(
                                  margin: EdgeInsetsDirectional.all(30.w),
                                  child: const CupertinoActivityIndicator())
                              : Container(
                                  margin: EdgeInsets.all(20.w),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8C00FF),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 80.w, vertical: 20.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        String? selectedLanguage =
                                            await getSelectedLanguageString();

                                        cubit.registerNewUser(
                                            name: nameController.text
                                                .trim()
                                                .toString(),
                                            email: emailController.text
                                                .trim()
                                                .toString(),
                                            password: passwordController.text
                                                .trim()
                                                .toString(),
                                            language: selectedLanguage ??
                                                "Not Defined");
                                      }
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),

                          // line
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 60.w),
                            child: const Expanded(
                              child: Divider(
                                color: Color(0x208C00FF),
                              ),
                            ),
                          ),

                          // already learner button
                          Container(
                            child: MaterialButton(
                                onPressed: () {
                                  // go to SignInScreen

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()));
                                },
                                child: const Text(
                                  'Already a learner? Sign in',
                                  style: TextStyle(
                                    color: Color(0xFF8C00FF),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (BuildContext context, Object? state) async {
            if (state is SaveDataSuccessState) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hasSeenWelcome', true);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
          },
        ));
  }
}
