import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/matches_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AI-ASSISTED: Dark Mode state management - ใช้ boolean เก็บสถานะ theme
  bool _isDarkMode = false;
  bool _showOnboarding = true;

  // AI-ASSISTED: Function toggle theme สำหรับเปลี่ยนโหมด Dark/Light
  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void completeOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // AI-ASSISTED: ใช้ InheritedWidget (ThemeProvider) ส่ง theme state ไปทั้งแอป
    return ThemeProvider(
      isDarkMode: _isDarkMode,
      toggleTheme: toggleTheme,
      child: MaterialApp(
        title: 'MatchUp',
        debugShowCheckedModeBanner: false,
        // AI-ASSISTED: กำหนด Light Theme
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE91E63),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Sarabun',
        ),
        // AI-ASSISTED: กำหนด Dark Theme
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE91E63),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Sarabun',
        ),
        // AI-ASSISTED: เลือก theme ตามสถานะ _isDarkMode
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        // AI-ASSISTED: แสดง Onboarding ก่อนเข้าแอปหลัก
        home: _showOnboarding
            ? OnboardingScreen(onComplete: completeOnboarding)
            : const MainNavigation(),
      ),
    );
  }
}

// AI-ASSISTED: Main Navigation with Bottom Navigation Bar - ใช้ Navigator สลับหน้า
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // AI-ASSISTED: รายการ 3 หน้าจอหลัก
  final List<Widget> _screens = [
    const ProfileScreen(),
    const PreferencesScreen(),
    const MatchesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AI-ASSISTED: ใช้ IndexedStack เพื่อเก็บ state ของแต่ละหน้า
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // AI-ASSISTED: Bottom Navigation Bar สำหรับสลับระหว่าง 3 หน้าจอ
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'ตั้งค่า',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'จับคู่',
          ),
        ],
      ),
    );
  }
}
