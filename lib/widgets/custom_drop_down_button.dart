import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';

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
          width: 0.4.sw, // Set width to 30% of the screen width
          height: 40.h, // Slightly reduced height for a more compact design
          padding: EdgeInsets.symmetric(horizontal: 8.w), // Adjusted padding
          decoration: BoxDecoration(
            color: kAppBarColor,
            borderRadius: BorderRadius.circular(8.r), // Adjusted border radius
          ),
          child: DropdownButton<String>(
            isExpanded:
                true, // Make the dropdown button expand to fill the container
            borderRadius: BorderRadius.circular(8.r),
            dropdownColor: kAppBarColor,
            value: selectedValue,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 20.sp, // Reduced icon size
            elevation: 16,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp), // Slightly smaller font size
            underline: Container(
              height: 0, // Remove underline
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
                child: FutureBuilder<String>(
                  future:
                      LocalizationService().fetchFromFirestore(value, value),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? '',
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
