import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/widgets/custom_drop_down_button.dart';
import 'package:translate_and_learn_app/widgets/translator_card_icons.dart';

class Languagecard extends StatefulWidget {
  final String text;
  final Color color;

  const Languagecard({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  State<Languagecard> createState() => _LanguagecardState();
}

class _LanguagecardState extends State<Languagecard> {
  bool isFavorite = false;

  @override
  void didUpdateWidget(covariant Languagecard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() {
        isFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        child: Padding(
            padding: EdgeInsets.all(16.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomDropDownButton(
                    translation: 0,
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.copy,
                      color: kAppBarColor,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Text copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                BlocBuilder<StudyWordsCubit, StudyWordsState>(
                  builder: (context, state) {
                    return state.isLoading
                        ? const CircularProgressIndicator()
                        : TranslatorCardicons(
                            icon1: isFavorite
                                ? FontAwesomeIcons.solidStar
                                : FontAwesomeIcons.star,
                            icon2: FontAwesomeIcons.volumeHigh,
                            icon3: FontAwesomeIcons.plus,
                            onPressed3: () {
                              if (widget.text.isNotEmpty) {
                                BlocProvider.of<StudyWordsCubit>(context)
                                    .addNewWords(
                                  BlocProvider.of<StudyWordsCubit>(context)
                                      .state
                                      .languageTo,
                                  widget.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Wait for words to be added'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Cannot add an empty translation to study words'),
                                  ),
                                );
                              }
                            },
                            onPressed1: () {
                              if (widget.text.isNotEmpty) {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                BlocProvider.of<FavoritesCubit>(context)
                                    .addFavoriteTranslation(widget.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFavorite
                                        ? 'Added to favorites'
                                        : 'Removed from favorites'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Cannot add an empty translation to favorites'),
                                  ),
                                );
                              }
                            },
                          );
                  },
                ),
              ]),
            ])));
  }
}
