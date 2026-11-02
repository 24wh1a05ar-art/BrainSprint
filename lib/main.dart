import 'package:flutter/material.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(const BrainSprintApp());
}

class BrainSprintApp extends StatelessWidget {
  const BrainSprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainSprint',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color background = Color(0xFF101126);
  static const Color purple = Color(0xFF8065F6);
  static const Color cardColor = Color(0xFF1D1E38);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int quizzesCompleted = 0;
  int correctAnswers = 0;
  int totalQuestions = 0;

  double get accuracy {
    if (totalQuestions == 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }

  Future<void> startQuiz(String category) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(category: category),
      ),
    );

    if (!mounted || result == null) return;

    final score = result['score'] as int;
    final total = result['total'] as int;

    setState(() {
      quizzesCompleted++;
      correctAnswers += score;
      totalQuestions += total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    color: HomeScreen.purple,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'BrainSprint',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    backgroundColor: HomeScreen.cardColor,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Text(
                'Hello, Learner! 👋',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ready to challenge\nyour brain?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8065F6),
                      Color(0xFF5741B8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ready for a quick challenge?',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Test your knowledge and improve your skills.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () => startQuiz('Programming'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: HomeScreen.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 13,
                        ),
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Explore Categories',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  CategoryCard(
                    title: 'Programming',
                    icon: Icons.code,
                    color: const Color(0xFF8065F6),
                    onTap: () => startQuiz('Programming'),
                  ),
                  CategoryCard(
                    title: 'General Knowledge',
                    icon: Icons.public,
                    color: const Color(0xFF29B6A5),
                    onTap: () => startQuiz('General Knowledge'),
                  ),
                  CategoryCard(
                    title: 'Science',
                    icon: Icons.science,
                    color: const Color(0xFFE99A43),
                    onTap: () => startQuiz('Science'),
                  ),
                  CategoryCard(
                    title: 'Mathematics',
                    icon: Icons.calculate,
                    color: const Color(0xFFE76B91),
                    onTap: () => startQuiz('Mathematics'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: HomeScreen.cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProgressItem(
                      value: '$quizzesCompleted',
                      label: 'Quizzes',
                    ),
                    ProgressItem(
                      value: '$correctAnswers',
                      label: 'Correct',
                    ),
                    ProgressItem(
                      value: '${accuracy.toStringAsFixed(0)}%',
                      label: 'Accuracy',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  quizzesCompleted == 0
                      ? 'Complete your first quiz to track your progress!'
                      : 'Keep going! You have completed $quizzesCompleted quizzes.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
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

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: HomeScreen.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressItem extends StatelessWidget {
  final String value;
  final String label;

  const ProgressItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: HomeScreen.purple,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white60),
        ),
      ],
    );
  }
}