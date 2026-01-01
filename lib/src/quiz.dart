import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

////////////////////////////////////////////

final List<Map<String, Object>> _questions = [
    {
      'question': 'What does "sustainability" mean?',
      'answers': [
        {'text': 'Using resources responsibly', 'correct': true},
        {'text': 'Using resources quickly', 'correct': false},
        {'text': 'Ignoring the environment', 'correct': false},
        {'text': 'Wasting materials', 'correct': false},
      ],
    },
    {
      'question': 'Which energy source is renewable?',
      'answers': [
        {'text': 'Solar', 'correct': true},
        {'text': 'Coal', 'correct': false},
        {'text': 'Gasoline', 'correct': false},
        {'text': 'Diesel', 'correct': false},
      ],
    },
    {
      'question': 'what is my name ?',
      'answers': [
        {'text': 'ammar', 'correct': false},
        {'text': 'mahmoud', 'correct': false},
        {'text': 'mohammed', 'correct': true},
        {'text': 'omar', 'correct': false},
      ],
    },
  ];

  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedIndex;

  late final AudioPlayer _sfxCorrect;
  late final AudioPlayer _sfxWrong;

  @override
  void initState() {
    super.initState();
    _sfxCorrect = AudioPlayer();
    _sfxWrong = AudioPlayer();
    _sfxCorrect.setVolume(0.9);
    _sfxWrong.setVolume(0.9);
  }

  @override
  void dispose() {
    _sfxCorrect.dispose();
    _sfxWrong.dispose();
    super.dispose();
  }

  void _answerQuestion(int index, bool isCorrect) async {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedIndex = index;
      if (isCorrect) _score++;
    });
//////////////////////////////////////////////////////////////////
    if (isCorrect) {
      await _sfxCorrect.stop();
      await _sfxCorrect.play(AssetSource('assets/sound/correct.mp3'));
    } else {
      await _sfxWrong.stop();
      await _sfxWrong.play(AssetSource('assets/sound/worng.mp3'));
    } 

    await Future.delayed(const Duration(milliseconds: 900));
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
        _answered = false;
        _selectedIndex = null;
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Finished!'),
        content: Text('Your score: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestion = 0;
                _score = 0;
                _answered = false;
                _selectedIndex = null;
              });
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
    final answers = q['answers'] as List<Map<String, Object>>;

    return Scaffold(
      appBar: AppBar(title: const Text('Sustainability Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              q['question'] as String,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),

            // توليد الأزرار مع ألوان ديناميكية
            ...List.generate(answers.length, (i) {
              final isCorrect = answers[i]['correct'] as bool;
              final isSelected = _selectedIndex == i;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () {
                    if (_answered) return;
                    _answerQuestion(i, isCorrect);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ).copyWith(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (_answered && isCorrect) return Colors.green;
                      if (_answered && isSelected && !isCorrect) {
                        return Colors.red;
                      }
                      return null;
                    }),
                  ),
                  child: Text(answers[i]['text'] as String),
                ),
              );
            }),

            const SizedBox(height: 20),
            Text(
              'Score: $_score',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
