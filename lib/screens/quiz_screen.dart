import 'dart:async';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int? selectedAnswer;
  bool answerSubmitted = false;
  int score = 0;

  static const int quizDuration = 60;
  int remainingSeconds = quizDuration;

  Timer? quizTimer;
  bool isFinishing = false;

  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    startTimer();
  }

  void loadQuestions() {
    if (widget.category == 'Programming') {
      questions = [
        {
          'question': 'Which language is used for Flutter development?',
          'options': ['Java', 'Dart', 'Python', 'C++'],
          'answer': 1,
        },
        {
          'question': 'Which keyword is used to create a class in Dart?',
          'options': ['function', 'define', 'class', 'object'],
          'answer': 2,
        },
        {
          'question': 'Which widget is used for displaying a vertical list?',
          'options': ['Row', 'Column', 'Stack', 'Container'],
          'answer': 1,
        },
        {
          'question': 'Which function is the starting point of a Dart app?',
          'options': ['start()', 'main()', 'run()', 'init()'],
          'answer': 1,
        },
        {
          'question': 'Which widget is used to respond to button taps?',
          'options': ['Text', 'Icon', 'ElevatedButton', 'Image'],
          'answer': 2,
        },
      ];
    } else if (widget.category == 'Science') {
      questions = [
        {
          'question': 'Which planet is known as the Red Planet?',
          'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
          'answer': 1,
        },
        {
          'question': 'What is the chemical symbol for water?',
          'options': ['CO2', 'O2', 'H2O', 'NaCl'],
          'answer': 2,
        },
        {
          'question': 'Which gas do plants absorb?',
          'options': ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'],
          'answer': 2,
        },
        {
          'question': 'What is the center of an atom called?',
          'options': ['Electron', 'Nucleus', 'Proton', 'Shell'],
          'answer': 1,
        },
        {
          'question': 'How many bones are there in an adult human body?',
          'options': ['206', '210', '201', '250'],
          'answer': 0,
        },
      ];
    } else if (widget.category == 'Mathematics') {
      questions = [
        {
          'question': 'What is 12 × 8?',
          'options': ['84', '96', '108', '88'],
          'answer': 1,
        },
        {
          'question': 'What is the square root of 144?',
          'options': ['10', '11', '12', '14'],
          'answer': 2,
        },
        {
          'question': 'What is 25% of 200?',
          'options': ['25', '40', '50', '75'],
          'answer': 2,
        },
        {
          'question': 'What is the value of 7²?',
          'options': ['14', '49', '21', '42'],
          'answer': 1,
        },
        {
          'question': 'How many degrees are in a right angle?',
          'options': ['45°', '90°', '180°', '360°'],
          'answer': 1,
        },
      ];
    } else if (widget.category == 'General Knowledge') {
      questions = [
        {
          'question': 'What is the capital of India?',
          'options': ['Mumbai', 'New Delhi', 'Hyderabad', 'Chennai'],
          'answer': 1,
        },
        {
          'question': 'Who is known as the Father of the Nation in India?',
          'options': [
            'Jawaharlal Nehru',
            'Mahatma Gandhi',
            'B. R. Ambedkar',
            'Subhas Chandra Bose',
          ],
          'answer': 1,
        },
        {
          'question': 'Which is the largest ocean in the world?',
          'options': ['Atlantic', 'Indian', 'Pacific', 'Arctic'],
          'answer': 2,
        },
        {
          'question': 'How many continents are there?',
          'options': ['5', '6', '7', '8'],
          'answer': 2,
        },
        {
          'question': 'Which is the national animal of India?',
          'options': ['Lion', 'Elephant', 'Tiger', 'Leopard'],
          'answer': 2,
        },
      ];
    } else {
      questions = [];
    }
  }

  void startTimer() {
    quizTimer?.cancel();

    quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || isFinishing) {
        timer.cancel();
        return;
      }

      if (remainingSeconds <= 1) {
        setState(() {
          remainingSeconds = 0;
        });

        finishQuiz();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  // Show result screen and receive its response.
  Future<void> finishQuiz() async {
    if (isFinishing) return;

    isFinishing = true;
    quizTimer?.cancel();

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: score,
          total: questions.length,
          category: widget.category,
        ),
      ),
    );

    if (!mounted) return;

    // Retry the same quiz without returning to Home.
    if (result?['retry'] == true) {
      setState(() {
        currentQuestion = 0;
        selectedAnswer = null;
        answerSubmitted = false;
        score = 0;
        remainingSeconds = quizDuration;
        isFinishing = false;
      });

      startTimer();
      return;
    }

    // Return the final score directly to Home Screen.
    Navigator.pop(context, result);
  }

  void submitAnswer() {
    if (selectedAnswer == null || answerSubmitted || isFinishing) {
      return;
    }

    setState(() {
      answerSubmitted = true;

      if (selectedAnswer == questions[currentQuestion]['answer']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (!answerSubmitted || isFinishing) return;

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answerSubmitted = false;
      });
    } else {
      finishQuiz();
    }
  }

  Future<void> confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D1E38),
          title: const Text(
            'Leave Quiz?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Your current quiz progress will not be counted.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Continue Quiz'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Leave',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (shouldExit == true && mounted) {
      quizTimer?.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    quizTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF101126),
        body: const Center(
          child: Text(
            'No questions available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final question = questions[currentQuestion];
    final isTimeLow = remainingSeconds <= 10;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          confirmExit();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF101126),
        appBar: AppBar(
          backgroundColor: const Color(0xFF101126),
          foregroundColor: Colors.white,
          title: Text(widget.category),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: confirmExit,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestion + 1} of ${questions.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: isTimeLow
                            ? Colors.redAccent
                            : const Color(0xFF8065F6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '0:${remainingSeconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: isTimeLow
                              ? Colors.redAccent
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              LinearProgressIndicator(
                value: (currentQuestion + 1) / questions.length,
                backgroundColor: Colors.white12,
                color: const Color(0xFF8065F6),
                minHeight: 7,
                borderRadius: BorderRadius.circular(10),
              ),

              const SizedBox(height: 35),

              Text(
                question['question'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              ...List.generate(
                question['options'].length,
                (index) {
                  final isSelected = selectedAnswer == index;
                  final correctAnswer = question['answer'] == index;

                  Color answerColor = const Color(0xFF1D1E38);

                  if (answerSubmitted && correctAnswer) {
                    answerColor = Colors.green;
                  } else if (answerSubmitted && isSelected) {
                    answerColor = Colors.red;
                  } else if (isSelected) {
                    answerColor = const Color(0xFF8065F6);
                  }

                  return GestureDetector(
                    onTap: () {
                      if (answerSubmitted || isFinishing) return;

                      setState(() {
                        selectedAnswer = index;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: answerColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: answerColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              question['options'][index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (answerSubmitted && correctAnswer)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                          if (answerSubmitted &&
                              isSelected &&
                              !correctAnswer)
                            const Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              if (isTimeLow)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      'Hurry up! Time is running out.',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: answerSubmitted
                      ? nextQuestion
                      : (selectedAnswer == null ? null : submitAnswer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8065F6),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    answerSubmitted
                        ? (currentQuestion == questions.length - 1
                            ? 'Finish Quiz'
                            : 'Next Question')
                        : 'Submit Answer',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String category;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        total == 0 ? 0 : ((score / total) * 100).round();

    String message;
    IconData resultIcon;

    if (percentage >= 80) {
      message = 'Excellent! Amazing work!';
      resultIcon = Icons.emoji_events;
    } else if (percentage >= 50) {
      message = 'Good job! Keep improving!';
      resultIcon = Icons.thumb_up;
    } else {
      message = 'Keep practicing! You can do it!';
      resultIcon = Icons.trending_up;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF101126),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                resultIcon,
                color: const Color(0xFFFFC857),
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                'Quiz Completed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                category,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '$score / $total',
                      style: const TextStyle(
                        color: Color(0xFF8065F6),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Your Score',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      '$percentage% Accuracy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    LinearProgressIndicator(
                      value: total == 0 ? 0 : score / total,
                      minHeight: 9,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFF8065F6),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'retry': true});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8065F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Retry Quiz',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'score': score,
                      'total': total,
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFF8065F6),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}