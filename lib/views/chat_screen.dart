import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/gemini_chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<GeminiChatCubit, GeminiChatState>(
        builder: (context, state) {
          return Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 100.h,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return GestureDetector(
                      onTap: () {
                        _showOptions(context, message, index);
                      },
                      child: Align(
                        alignment: message.isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: message.isUserMessage
                                ? kTranslatorcardColor
                                : kTranslationCardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: message.isUserMessage
                                  ? const Radius.circular(12)
                                  : const Radius.circular(0),
                              bottomRight: message.isUserMessage
                                  ? const Radius.circular(0)
                                  : const Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: message.isUserMessage ? 50 : 10,
                            right: message.isUserMessage ? 10 : 50,
                          ),
                          child: Text(
                            message.text.replaceAll('*', ''),
                            style: TextStyle(
                              fontWeight: message.isUserMessage
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPurpil),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPurpil),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: kGeminiColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: kGeminiColor),
                      onPressed: () {
                        final message = _controller.text;
                        _controller.clear();
                        context.read<GeminiChatCubit>().translateText(message);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showOptions(BuildContext context, Message message, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.text));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                context.read<GeminiChatCubit>().deleteMessage(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
