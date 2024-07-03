import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Register_States.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void changeVisibility() {
    emit(UpdatePassVisibility());
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
