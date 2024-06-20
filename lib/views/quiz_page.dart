import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/answers_cubit.dart';
import 'package:translate_and_learn_app/cubit/cubit/quiz_cubit.dart';
import 'package:translate_and_learn_app/cubit/cubit/proof_cubit.dart';
import 'package:translate_and_learn_app/views/score_page.dart';
import 'package:translate_and_learn_app/widgets/text_container.dart'; // Import the score page

class QuizPage extends StatefulWidget {
  final List<String> words;
  final String language;

  const QuizPage({super.key, required this.words, required this.language});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuizCubit _quizCubit;
  late AnswersCubit _answersCubit;
  late ProofCubit _proofCubit;
  int _currentWordIndex = 0;
  late List<String> _shuffledWords;
  int _score = 0;
  String? _selectedAnswer;
  bool _answerSubmitted = false;
  int totalScore = 0;

  @override
  void initState() {
    super.initState();
    _shuffledWords = widget.words.toList()..shuffle();
    _quizCubit = QuizCubit(
      GenerativeModel(apiKey: kAPIKEY, model: 'gemini-1.5-flash'),
    );
    _answersCubit = AnswersCubit(
      GenerativeModel(apiKey: kAPIKEY, model: 'gemini-1.5-flash'),
    );
    _proofCubit = ProofCubit(
      GenerativeModel(apiKey: kAPIKEY, model: 'gemini-1.5-flash'),
    );
    _generateNextQuestion();
  }

  void _generateNextQuestion() {
    if (_currentWordIndex < _shuffledWords.length) {
      final word = _shuffledWords[_currentWordIndex];
      _quizCubit.generateQuestion(widget.language, word);
      _answersCubit.getAnswers(widget.language, word, word).then((answers) {
        setState(() {
          _selectedAnswer = null; // Reset selected answer for the new question
          _answerSubmitted = false;
        });
      });
      _proofCubit.getAnswers(widget.language, word, word);
    } else {
      _onFinishQuiz(); // Navigate to the score page if all words are done
    }
  }

  void _onSubmitAnswer() {
    setState(() {
      _answerSubmitted = true;
      if (_selectedAnswer != null &&
          _selectedAnswer!.toLowerCase() ==
              _shuffledWords[_currentWordIndex].toLowerCase()) {
        _score++;
      }
      totalScore++;
    });
  }

  void _onNextQuestion() {
    setState(() {
      _currentWordIndex++;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _quizCubit),
        BlocProvider(create: (context) => _answersCubit),
        BlocProvider(create: (context) => _proofCubit),
      ],
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
                                  child: TextContainer(
                                    title: "Question",
                                    content: Center(
                                      child: Text(
                                        state.question,
                                        style: TextStyle(fontSize: 24.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ));
                            } else if (state is QuizError) {
                              return Center(child: Text(state.message));
                            }
                            return Container();
                          },
                        ),
                        BlocBuilder<AnswersCubit, AnswersState>(
                          builder: (context, state) {
                            if (state is AnswersInitial) {
                              return const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ));
                            } else if (state is AnswersGenerated) {
                              // Display only four choices from the list of answers
                              final choices = state.answers.take(4).toList();
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: _answerSubmitted
                                          ? _selectedAnswer ==
                                                  _shuffledWords[
                                                      _currentWordIndex]
                                              ? Colors.green
                                              : Colors.red
                                          : kTranslationCardColor,
                                      width: 3,
                                    ),
                                  ),
                                  child: Column(
                                    children: choices.map((answer) {
                                      return RadioListTile<String>(
                                        title: Text(answer),
                                        value: answer,
                                        groupValue: _selectedAnswer,
                                        onChanged: _answerSubmitted
                                            ? null
                                            : (value) {
                                                setState(() {
                                                  _selectedAnswer = value;
                                                });
                                              },
                                        activeColor: _answerSubmitted
                                            ? answer ==
                                                    _shuffledWords[
                                                        _currentWordIndex]
                                                ? Colors.green
                                                : answer == _selectedAnswer
                                                    ? Colors.red
                                                    : Colors.grey
                                            : Colors.grey,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else if (state is AnswersError) {
                              return Center(child: Text(state.message));
                            }
                            return Container();
                          },
                        ),
                        if (_answerSubmitted)
                          BlocBuilder<ProofCubit, ProofState>(
                            builder: (context, state) {
                              if (state is ProofInitial) {
                                return const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ));
                              } else if (state is ProofGenerated) {
                                return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextContainer(
                                      title:
                                          "Correct Answer: ${_shuffledWords[_currentWordIndex]} ",
                                      content: Text(
                                        ' Proof: ${state.proof}',
                                        style: TextStyle(fontSize: 16.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              } else if (state is ProofError) {
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
                                  SizedBox(
                                      width: 50.w), // Add space between buttons
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
