import 'package:flutter/material.dart';

// AI-ASSISTED: InheritedWidget สำหรับส่ง Theme state ไปทั้งแอป
class ThemeProvider extends InheritedWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ThemeProvider({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required super.child,
  });

  // AI-ASSISTED: Static method เพื่อเข้าถึง ThemeProvider จาก context
  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}
