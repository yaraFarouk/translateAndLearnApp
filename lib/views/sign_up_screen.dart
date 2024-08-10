import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/cubit/register/Register_Cubit.dart';
import 'package:translate_and_learn_app/cubit/register/Register_States.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
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
  final LocalizationService _localizationService = LocalizationService();
  late Future<String> _alreadyTranslation;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguageString();
    _alreadyTranslation = _localizationService.fetchFromFirestore(
        'Already a learner? Sign in', 'Already a learner? Sign in');
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

                              // Sign up text
                              Container(
                                margin: EdgeInsets.only(top: 20.h),
                                child: const Text(
                                  'Let\'s sign you up!',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // name input
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter your name';
                          },
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: FutureBuilder<String>(
                              future: LocalizationService().fetchFromFirestore(
                                'Name',
                                'Name',
                              ),
                              builder: (context, snapshot) {
                                return Text(snapshot.data ?? '');
                              },
                            ),
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Email input
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a valid email';
                            }
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: FutureBuilder<String>(
                              future: LocalizationService().fetchFromFirestore(
                                'Email',
                                'Email',
                              ),
                              builder: (context, snapshot) {
                                return Text(snapshot.data ?? '');
                              },
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // password input
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Password is empty';
                          },
                          obscureText: passHidden,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            label: FutureBuilder<String>(
                              future: LocalizationService().fetchFromFirestore(
                                'Password',
                                'Password',
                              ),
                              builder: (context, snapshot) {
                                return Text(snapshot.data ?? '');
                              },
                            ),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passHidden = !passHidden;
                                });
                              },
                              icon: const Icon(Icons.remove_red_eye_outlined),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Sign up button
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
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      String? selectedLanguage =
                                          await getSelectedLanguageString();

                                      cubit.registerNewUser(
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          password: passwordController.text,
                                          language: selectedLanguage ??
                                              "Not Defined");
                                    }
                                  },
                                  child: FutureBuilder<String>(
                                    future: LocalizationService()
                                        .fetchFromFirestore(
                                      'Sign Up',
                                      'Sign Up',
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                        SizedBox(height: 20.h),

                        // line
                        const Divider(
                          color: Color(0x208C00FF),
                        ),

                        SizedBox(height: 10.h),

                        // already learner button
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              // go to SignInScreen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen()));
                            },
                            child: FutureBuilder<String>(
                              future: _alreadyTranslation,
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF8C00FF),
                                  ),
                                );
                              },
                            ),
                          ),
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

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false);
          }
        },
      ),
    );
  }
}
