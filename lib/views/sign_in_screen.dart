import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/views/home_view.dart';

import '../cubit/register/Register_Cubit.dart';
import '../cubit/register/Register_States.dart';

class SignInScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {

    var formKey = GlobalKey<FormState>();

    var emailController    = TextEditingController();
    var passwordController = TextEditingController();

    var passHidden = true;

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state)
        {

          var cubit = RegisterCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: Text(
                            'Already a learner? let\'s find out!',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: TextFormField(
                            validator: (value)
                            {
                              if(value!.isEmpty) return 'Enter a valid email';
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                                label: Text('Email'),
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsetsDirectional.all(20),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value)
                            {
                              if(value!.isEmpty) return 'Password is empty';
                            },

                            obscureText: passHidden,

                            keyboardType: TextInputType.visiblePassword,

                            decoration: InputDecoration(
                                label: Text('Password'),
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                    onPressed: ()
                                    {
                                      passHidden = !passHidden;
                                      cubit.changeVisibility();
                                    },
                                    icon : Icon(Icons.remove_red_eye_outlined)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ),

                        state is LoginLoadingState
                            ?
                        Container(
                            margin: EdgeInsetsDirectional.all(30),
                            child: CupertinoActivityIndicator()
                        )
                            :
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
                            onPressed: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                cubit.loginUser(
                                    email: emailController.text.trim().toString(),
                                    password: passwordController.text.trim().toString()
                                );
                              }
                            },
                            child: const Text(
                              'Sign In',
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
                              onPressed: ()
                              {
                                // go to SignInScreen

                                Navigator.pop(context);

                              },
                              child: const Text(
                                'Not a learner? Sign up',
                                style: TextStyle(
                                  color: Color(0xFF8C00FF),
                                ),
                              )
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
        listener: (BuildContext context, Object? state)
        {
          if(state is LoginSuccessState)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },

      ),
    );
  }
}
