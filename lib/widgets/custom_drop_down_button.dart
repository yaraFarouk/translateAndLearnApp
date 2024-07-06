import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownButton extends StatefulWidget {
  const CustomDropDownButton({super.key, required this.translation});
  final int translation;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String selectedValue = 'English';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150.w,
          height: 40.h,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: kAppBarColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              DropdownButton<String>(
                borderRadius: BorderRadius.circular(8),
                dropdownColor: kAppBarColor,
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: kAppBarColor, // No underline
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    // Update both the FavoritesCubit and GeminiApiCubit with the new selected language
                    if (widget.translation == 1) {
                      context
                          .read<FavoritesCubit>()
                          .updateLanguageFrom(selectedValue);
                      context
                          .read<GeminiApiCubit>()
                          .updateLanguageFrom(selectedValue);
                    } else if (widget.translation == 0) {
                      context
                          .read<FavoritesCubit>()
                          .updateLanguageTo(selectedValue);
                      context
                          .read<GeminiApiCubit>()
                          .updateLanguageTo(selectedValue);
                    }
                  });
                },
                items: <String>[
                  'English',
                  'Spanish',
                  'French',
                  'German',
                  'Italian',
                  'Portuguese',
                  'Chinese',
                  'Japanese',
                  'Polish',
                  'Turkish',
                  'Russian',
                  'Dutch',
                  'Korean'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
