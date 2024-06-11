import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';

class ResponseDisplayWidget extends StatelessWidget {
  const ResponseDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeminiApiCubit, GeminiApiState>(
      builder: (context, state) {
        if (state is GeminiApiLoading) {
          return const CircularProgressIndicator();
        } else if (state is GeminiApiSuccess) {
          return Text(state.response,
              style: const TextStyle(fontSize: 16, color: Colors.black));
        } else if (state is GeminiApiError) {
          return Text(state.error,
              style: const TextStyle(fontSize: 16, color: Colors.red));
        }
        return Container(); // Initial state or other states
      },
    );
  }
}
