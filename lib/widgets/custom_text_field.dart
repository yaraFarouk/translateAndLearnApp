import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hint, this.onChanged});
  final String hint;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<GeminiApiCubit>().translateText(value);
      },
      maxLines: null,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(kTranslatorcardColor),
      ),
    );
  }

  OutlineInputBorder buildBorder([color]) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: color ?? kTranslatorcardColor,
        ));
  }
}
