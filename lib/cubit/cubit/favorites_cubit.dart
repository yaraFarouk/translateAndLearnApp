import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:translate_and_learn_app/models/favorite_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FavoritesCubit() : super(FavoritesInitial());

  String languageFrom = 'English', languageTo = 'English', text = '';

  void updateLanguageFrom(String language) {
    languageFrom = language;
  }

  void updateLanguageTo(String language) {
    languageTo = language;
  }

  void updateText(String text_) {
    text = text_;
  }

  Future<void> translateText(String translation) async {
    emit(FavoritesInitial());

    try {
      emit(FavoritesLoading());

      emit(FavoritesSuccess());
    } catch (e) {
      emit(FavoritesError("Error occurred during add to favorite"));
    }
  }

  Future<void> addFavoriteTranslation(String translationText) async {
    final favorite = FavoriteModel(
      languageFrom: languageFrom,
      langugaeTo: languageTo,
      text: text,
      translation: translationText,
    );
    User? user = _auth.currentUser;
    try {
      await firestore
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .add(favorite.toMap());
      emit(FavoritesSuccess());
    } catch (e) {
      emit(FavoritesError("Error occurred during adding to favorites"));
    }
  }
}
