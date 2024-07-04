part of 'gemini_chat_cubit.dart';

@immutable
abstract class GeminiChatState {
  final List<Message> messages;
  const GeminiChatState(this.messages);

  @override
  List<Object> get props => [messages];
}

class GeminiChatInitial extends GeminiChatState {
  const GeminiChatInitial(super.messages);
}

class GeminiChatLoading extends GeminiChatState {
  const GeminiChatLoading(super.messages);
}

class GeminiChatSuccess extends GeminiChatState {
  const GeminiChatSuccess(super.messages);
}

class GeminiChatError extends GeminiChatState {
  final String error;
  const GeminiChatError(this.error, List<Message> messages) : super(messages);

  @override
  List<Object> get props => [error, messages];
}

class Message {
  final String text;
  final bool isUserMessage;
  final int? responseIndex;

  Message(
      {required this.text, required this.isUserMessage, this.responseIndex});

  Message copyWith({String? text, bool? isUserMessage, int? responseIndex}) {
    return Message(
      text: text ?? this.text,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      responseIndex: responseIndex ?? this.responseIndex,
    );
  }
}
