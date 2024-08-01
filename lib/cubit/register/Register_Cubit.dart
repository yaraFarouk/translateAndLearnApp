import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      {required name, required email, required password, required language}) {
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

      emit(RegisterNewUserErrorState());
    });
  }

  void loginUser({required email, required password}) {
    emit(LoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('Logged in Successfully');

      // CacheHelper.saveValue(key: 'UID', value: value.user!.uid);

      emit(LoginSuccessState());
    }).catchError((onError) {
      print(onError.toString());

      print(onError.toString());

      emit(LoginErrorState());
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
