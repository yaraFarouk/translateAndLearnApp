import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'translator_card_state.dart';

class TranslatorCardCubit extends Cubit<TranslatorCardState> {
  TranslatorCardCubit() : super(TranslatorCardInitial());

  void changeToText() {
    emit(TranslatorCardTextSelected());
  }

  void changeToMicrophone() {
    emit(TranslatorCardMicrophoneSelected());
  }

  void changeToCamera() {
    emit(TranslatorCardCameraSelected());
  }
}
