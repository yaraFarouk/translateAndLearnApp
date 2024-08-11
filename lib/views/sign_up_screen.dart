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

  bool passHidden = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? nameLabel;
  String? emailLabel;
  String? passwordLabel;
  String? signUpLabel;
  String? alreadyLearnerText;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguageString();
    _loadLabels();
  }

  Future<void> _loadSelectedLanguageString() async {
    String? languageString = await getSelectedLanguageString();
    setState(() {
      selectedLanguageString = languageString;
    });
  }

  Future<void> _loadLabels() async {
    nameLabel = await LocalizationService().fetchFromFirestore('Name', 'Name');
    emailLabel = await LocalizationService().fetchFromFirestore('Email', 'Email');
    passwordLabel = await LocalizationService().fetchFromFirestore('Password', 'Password');
    signUpLabel = await LocalizationService().fetchFromFirestore('Sign Up', 'Sign Up');
    alreadyLearnerText = await LocalizationService().fetchFromFirestore(
        'Already a learner? Sign in', 'Already a learner? Sign in');

    // Ensure the labels are loaded and the UI is updated
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
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

                        // Name input
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter your name';
                          },
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: nameLabel ?? '',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),

                        SizedBox(height: 20.h),

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

                        // Sign Up button
                        state is RegisterNewUserLoadingState
                            ? Center(
                              child: Container(
                              margin: EdgeInsets.only(top: 20.h),
                              child: const CupertinoActivityIndicator()),
                            )
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
                            child: Text(
                              signUpLabel ?? '',
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

                        // Already learner button
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              // Go to SignInScreen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SignInScreen()));
                            },
                            child: Text(
                              alreadyLearnerText ?? '',
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
          if ((state is SaveDataSuccessState) || (state is  RegisterNewUserSuccessState))
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasSeenWelcome', true);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                    (Route<dynamic> route) => false);
          }
          else if(state is RegisterNewUserErrorState)
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
