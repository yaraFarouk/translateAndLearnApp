part of 'translator_card_cubit.dart';

@immutable
abstract class TranslatorCardState {}

class TranslatorCardInitial extends TranslatorCardState {}

class TranslatorCardTextSelected extends TranslatorCardState {}

class TranslatorCardMicrophoneSelected extends TranslatorCardState {}

class TranslatorCardCameraSelected extends TranslatorCardState {}
