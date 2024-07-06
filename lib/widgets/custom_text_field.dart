import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
  });

  final String hint;
  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        // Update both the GeminiApiCubit and FavoritesCubit
        context.read<GeminiApiCubit>().translateText(value);
        context.read<FavoritesCubit>().updateText(value);
      },
      maxLines: null,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: widget.hint,
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
      ),
    );
  }
}
