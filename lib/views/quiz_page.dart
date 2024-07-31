import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/quiz_cubit.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/views/score_page.dart';
import 'package:translate_and_learn_app/widgets/text_container.dart';

class QuizPage extends StatefulWidget {
  final List<WordDetailsModel> words;
  final String language;

  const QuizPage({super.key, required this.words, required this.language});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuizCubit _quizCubit;
  int _currentWordIndex = 0;
  late List<WordDetailsModel> _shuffledWords;
  int _score = 0;
  String? _selectedAnswer;
  bool _answerSubmitted = false;
  int totalScore = 0;
  bool _isLastWord = false;

  @override
  void initState() {
    super.initState();
    _shuffledWords = widget.words.toList()..shuffle();
    _quizCubit = QuizCubit(
      GenerativeModel(apiKey: kAPIKEY, model: 'gemini-1.5-flash'),
    );
    _generateNextQuestion();
  }

  void _generateNextQuestion() {
    if (_currentWordIndex < _shuffledWords.length) {
      final word = _shuffledWords[_currentWordIndex];
      _quizCubit.generateQuestion(widget.language, word.word);
    } else {
      _onFinishQuiz();
    }
  }

  Future<void> _onSubmitAnswer() async {
    setState(() {
      _answerSubmitted = true;
    });

    bool isCorrect = _selectedAnswer != null &&
        _selectedAnswer!.toLowerCase() ==
            _shuffledWords[_currentWordIndex].word.toLowerCase();

    if (isCorrect) {
      _score++;
      await _quizCubit.updateProgress(
          widget.language, _shuffledWords[_currentWordIndex].word, true);
    } else {
      await _quizCubit.updateProgress(
          widget.language, _shuffledWords[_currentWordIndex].word, false);
    }

    totalScore++;

    if (_currentWordIndex == _shuffledWords.length - 1) {
      setState(() {
        _isLastWord = true;
      });
    }
  }

  void _onNextQuestion() {
    setState(() {
      _currentWordIndex++;
      _answerSubmitted = false; // Reset the answer submission state
      _selectedAnswer = null; // Reset the selected answer
      _generateNextQuestion();
    });
  }

  void _onFinishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScorePage(score: _score, totalScore: totalScore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _quizCubit,
      child: Scaffold(
        body: Stack(
          children: [
            _currentWordIndex == -1
                ? Center(
                    child: Text(
                      'Quiz Finished!\nYour Score: $_score/$totalScore',
                      style: TextStyle(fontSize: 24.sp),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.h),
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 100.h,
                            ),
                          ),
                        ),
                        BlocBuilder<QuizCubit, QuizState>(
                          builder: (context, state) {
                            if (state is QuizInitial) {
                              return const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ));
                            } else if (state is QuizQuestionGenerated) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextContainer(
                                      title: "Question",
                                      content: Center(
                                        child: Text(
                                          state.quizModel.question,
                                          style: TextStyle(fontSize: 24.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: _answerSubmitted
                                              ? _selectedAnswer ==
                                                      _shuffledWords[
                                                              _currentWordIndex]
                                                          .word
                                                  ? Colors.green
                                                  : Colors.red
                                              : kTranslationCardColor,
                                          width: 3,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          RadioListTile<String>(
                                            title:
                                                Text(state.quizModel.choice1),
                                            value: state.quizModel.choice1,
                                            groupValue: _selectedAnswer,
                                            onChanged: _answerSubmitted
                                                ? null
                                                : (value) {
                                                    setState(() {
                                                      _selectedAnswer = value;
                                                    });
                                                  },
                                            activeColor: _answerSubmitted
                                                ? state.quizModel.choice1 ==
                                                        _shuffledWords[
                                                                _currentWordIndex]
                                                            .word
                                                    ? Colors.green
                                                    : state.quizModel.choice1
                                                                .toLowerCase() ==
                                                            _selectedAnswer
                                                        ? Colors.red
                                                        : Colors.grey
                                                : Colors.grey,
                                          ),
                                          RadioListTile<String>(
                                            title:
                                                Text(state.quizModel.choice2),
                                            value: state.quizModel.choice2,
                                            groupValue: _selectedAnswer,
                                            onChanged: _answerSubmitted
                                                ? null
                                                : (value) {
                                                    setState(() {
                                                      _selectedAnswer = value;
                                                    });
                                                  },
                                            activeColor: _answerSubmitted
                                                ? state.quizModel.choice2 ==
                                                        _shuffledWords[
                                                                _currentWordIndex]
                                                            .word
                                                    ? Colors.green
                                                    : state.quizModel.choice2 ==
                                                            _selectedAnswer
                                                        ? Colors.red
                                                        : Colors.grey
                                                : Colors.grey,
                                          ),
                                          RadioListTile<String>(
                                            title:
                                                Text(state.quizModel.choice3),
                                            value: state.quizModel.choice3,
                                            groupValue: _selectedAnswer,
                                            onChanged: _answerSubmitted
                                                ? null
                                                : (value) {
                                                    setState(() {
                                                      _selectedAnswer = value;
                                                    });
                                                  },
                                            activeColor: _answerSubmitted
                                                ? state.quizModel.choice3 ==
                                                        _shuffledWords[
                                                                _currentWordIndex]
                                                            .word
                                                    ? Colors.green
                                                    : state.quizModel.choice3 ==
                                                            _selectedAnswer
                                                        ? Colors.red
                                                        : Colors.grey
                                                : Colors.grey,
                                          ),
                                          RadioListTile<String>(
                                            title:
                                                Text(state.quizModel.choice4),
                                            value: state.quizModel.choice4,
                                            groupValue: _selectedAnswer,
                                            onChanged: _answerSubmitted
                                                ? null
                                                : (value) {
                                                    setState(() {
                                                      _selectedAnswer = value;
                                                    });
                                                  },
                                            activeColor: _answerSubmitted
                                                ? state.quizModel.choice4 ==
                                                        _shuffledWords[
                                                                _currentWordIndex]
                                                            .word
                                                    ? Colors.green
                                                    : state.quizModel.choice4 ==
                                                            _selectedAnswer
                                                        ? Colors.red
                                                        : Colors.grey
                                                : Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_answerSubmitted)
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: TextContainer(
                                          title:
                                              "Correct Answer: ${_shuffledWords[_currentWordIndex].word}",
                                          content: Text(
                                            'Proof: ${state.quizModel.proof}',
                                            style: TextStyle(fontSize: 16.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else if (state is QuizError) {
                              return Center(child: Text(state.message));
                            }
                            return Container();
                          },
                        ),
                        if (_currentWordIndex >= 0 &&
                            _currentWordIndex < _shuffledWords.length)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: _onFinishQuiz,
                                    child: Text('Finish'),
                                  ),
                                  if (!_isLastWord) ...[
                                    SizedBox(
                                        width:
                                            50.w), // Add space between buttons
                                    ElevatedButton(
                                      onPressed: _answerSubmitted
                                          ? _onNextQuestion
                                          : _selectedAnswer != null
                                              ? _onSubmitAnswer
                                              : null,
                                      child: Text(
                                          _answerSubmitted ? 'Next' : 'Submit'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
