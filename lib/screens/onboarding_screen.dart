import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';

// AI-ASSISTED: หน้า Onboarding 3 หน้า ใช้ PageView
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // AI-ASSISTED: PageController สำหรับควบคุม PageView
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // AI-ASSISTED: ข้อมูล 3 หน้า Onboarding
  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.favorite,
      title: 'ยินดีต้อนรับสู่ MatchUp',
      description: 'แอปหาคู่ที่เน้นความเข้ากันได้\nไม่ใช่แค่รูปลักษณ์ภายนอก',
      color: Color(0xFFE91E63),
    ),
    OnboardingData(
      icon: Icons.tune,
      title: 'จัดลำดับความสำคัญ',
      description: 'บอกเราว่าคุณต้องการคุณสมบัติอะไร\nในคู่ของคุณมากที่สุด',
      color: Color(0xFF9C27B0),
    ),
    OnboardingData(
      icon: Icons.people,
      title: 'พบคนที่ใช่',
      description: 'ระบบจะจับคู่คุณกับคนที่\nมีความต้องการตรงกัน',
      color: Color(0xFF673AB7),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // AI-ASSISTED: ฟังก์ชันไปหน้าถัดไป หรือจบ Onboarding
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ปุ่มข้าม
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('ข้าม'),
                ),
              ),
            ),

            // AI-ASSISTED: PageView สำหรับ 3 หน้า Onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // AI-ASSISTED: Page Indicators ใช้ AnimatedContainer เปลี่ยนขนาด
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? _pages[index].color
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // AI-ASSISTED: ปุ่มถัดไป/เริ่มต้น พร้อม Animation
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage == _pages.length - 1 ? 'เริ่มต้นใช้งาน' : 'ถัดไป',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI-ASSISTED: TweenAnimationBuilder สำหรับ Animation icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.icon,
                    size: 80,
                    color: data.color,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 48),

          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// AI-ASSISTED: Model สำหรับเก็บข้อมูล Onboarding แต่ละหน้า
class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
