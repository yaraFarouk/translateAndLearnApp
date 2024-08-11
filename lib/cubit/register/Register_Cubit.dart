import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'Register_States.dart';

class UserData
{
  String? name;
  String? email;
  String? password;
  String? image;
  String? uid;

  UserData({
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.uid,
  });

  UserData.fromFire(Map<String, dynamic> fire) {
    name = fire['name'];
    email = fire['email'];
    password = fire['password'];
    image = fire['image'];
    uid = fire['uid'];
  }
}

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void changeVisibility() {
    emit(UpdatePassVisibility());
  }

  UserData? userModel;

  void getUserData(String UID) async
  {
    FirebaseFirestore.instance.collection('users').doc(UID).get().then((onValue)
    {
      userModel = UserData.fromFire(onValue.data()!);
    });
  }

  void registerNewUser(
      {required String name, required String email, required String password, required String language}) {
    emit(RegisterNewUserLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('Registered Successfully');

      userSaveData(
          name: name,
          email: email,
          UID: value.user!.uid,
          password: password,
          language: language);

      // CacheHelper.saveValue(key: 'UID', value: value.user!.uid);

      emit(RegisterNewUserSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      String err_msg;
      if (onError is FirebaseAuthException) {
        // Extract the error code
        switch (onError.code) {
          case 'invalid-email':
            err_msg = 'The email address is badly formatted.';
            break;
          case 'email-already-in-use':
            err_msg = 'The email address is already in use by another account.';
            break;
          case 'weak-password':
            err_msg = 'The password must be at least 6 characters.';
            break;
          case 'operation-not-allowed':
            err_msg = 'Email/Password accounts are not enabled.';
            break;
          default:
            err_msg = 'An unknown error occurred.';
        }
      } else {
        err_msg = 'An unexpected error occurred.';
      }

      emit(RegisterNewUserErrorState(err_msg));
    });
  }


  void loginUser({required String email, required String password}) {
    emit(LoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('Logged in Successfully');

      // CacheHelper.saveValue(key: 'UID', value: value.user!.uid);

      emit(LoginSuccessState());

    }).catchError((onError)
    {
      print(onError.toString());

      String err_msg;
      if (onError is FirebaseAuthException)
      {
        // Extract the error code
        switch (onError.code) {
          case 'invalid-email':
            err_msg = 'The email address is badly formatted.';
            break;
          case 'user-disabled':
            err_msg = 'The user corresponding to the given email has been disabled.';
            break;
          case 'user-not-found':
            err_msg = 'There is no user corresponding to the given email.';
            break;
          case 'wrong-password':
            err_msg = 'The password is invalid for the given email.';
            break;
          default:
            err_msg = 'An unknown error occurred.';
        }
      } else {
        err_msg = 'An unexpected error occurred.';
      }

      emit(LoginErrorState(err_msg));

    });
  }


  void userSaveData(
      {required String name,
      required String email,
      required String UID,
      required String password,
      required String language}) {
    FirebaseFirestore.instance.collection('users').doc(UID).set({
      'name': name,
      'email': email,
      'password': password,
      'language': language,
      'uid': UID
    }).then((value) {
      emit(SaveDataSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      emit(SaveDataErrorState());
    });
  }
}
