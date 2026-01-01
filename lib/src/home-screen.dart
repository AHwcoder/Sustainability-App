import 'dart:async';
import 'package:applapp/src/quiz.dart';
import 'package:flutter/material.dart';
import 'package:applapp/src/video.dart';
import 'package:applapp/src/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _images = [
    'https://www.lythouse.com/wp-content/uploads/2024/08/Carrolls-csr-pyramid-principles-and-examples-1.webp',
    'https://purebluesustainability.com/wp-content/uploads/2022/02/Environmental-Sustainability-Examples-Tips-to-Implement-Them.jpg',
    'https://e1.nmcdn.io/pmc/wp-content/uploads/2021/02/Economic-Sustainability-Examples.jpeg/v:1-width:2000-height:1500-fit:cover/Economic-Sustainability-Examples.webp?signature=1a35a5ce',
  ];

  late final PageController _page;
  int _current = 0;
  Timer? _timer;
  final String _articleIssues = '''
تشمل قضايا الاستدامة تغيّر المناخ، ندرة المياه، فقدان التنوع الحيوي، والهدر الغذائي.
تتأثر المجتمعات الفقيرة بشكلٍ غير متكافئ بهذه الآثار؛ فالأزمات البيئية تعني فقدان مصادر الرزق
وتدهور الصحة العامة وارتفاع تكاليف المعيشة. عالميًا، تُعد الطاقة النظيفة، النقل العام، إدارة النفايات،
وتبنّي الاقتصاد الدائري خطواتٍ رئيسية. كما تلعب التقنيات الخضراء—مثل كفاءة المباني والطاقة الشمسية
والتحليل البيئي بالبيانات—دورًا متناميًا في خفض الانبعاثات وتحسين جودة الحياة.
تتطلب الحلول تعاون الحكومات والشركات والمجتمع المدني مع تعليم يغيّر السلوك الاستهلاكي.
''';
  final String articleSolutions = '''
تشمل حلول الاستدامة تعزيز الطاقة المتجددة، تحسين كفاءة استخدام الموارد،
وتبني ممارسات الزراعة المستدامة. كما تلعب التقنيات الخضراء دورًا حيويًا في تقليل الانبعاثات
وتحسين جودة الحياة. تتطلب هذه الحلول تعاون الحكومات والشركات والمجتمع المدني،
إلى جانب تعليم يغيّر السلوك الاستهلاكي ويعزز الوعي البي
ئي.''';
  bool _showSolutions = false;
  String get _articleText => _showSolutions ? articleSolutions : _articleIssues;
  String get _articleTitle => _showSolutions
      ? 'حلول الاستدامة حول العالم'
      : 'قضايا الاستدامة حول العالم';
  String get _togglelabel => _showSolutions ? 'عرض القضايا' : 'عرض الحلول';

  @override
  void initState() {
    super.initState();
    _page = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (!mounted) return;
      final next = (_current + 1) % _images.length;
      _page.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  // helper moved out of build
  Widget _buildArticleBox(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double maxH = size.height * 0.28;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF6F8FF), Color(0xFFEFF3FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                left: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 6,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF5ABF90), Color(0xFF2E7D32)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(34, 16, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.public, size: 20, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text(
                          'قضايا الاستدامة حول العالم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxH),
                      child: Scrollbar(
                        thumbVisibility: true,
                        radius: Radius.circular(8),
                        child: SingleChildScrollView(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: Text(
                              _articleText,
                              key: ValueKey(_articleText),
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = size.height * 0.25;

    return Scaffold(
      appBar: AppBar(title: const Text('Sustainability App')),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              minimum: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: SizedBox(
                height: topHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: PageView.builder(
                    controller: _page,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemBuilder: (context, i) {
                      return Image.network(
                        _images[i],
                        fit: BoxFit.cover,
                        loadingBuilder: (c, w, p) => p == null
                            ? w
                            : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (c, e, s) => const ColoredBox(
                          color: Colors.black12,
                          child: Center(child: Text('Image failed to load')),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.25),
            child: _buildArticleBox(context),
          ),
          Align(
            alignment: Alignment(0, 0.65),
            child: SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showSolutions = !_showSolutions;
                    });
                  },
                  icon: Icon(_showSolutions ? Icons.article : Icons.lightbulb),
                  label: Text(_togglelabel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuizScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Start Quiz'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VideoScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Watch Video'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
