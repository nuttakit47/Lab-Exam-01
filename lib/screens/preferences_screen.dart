import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_button.dart';
import '../models/preference_item.dart';

// AI-ASSISTED: หน้า Preferences ใช้ ReorderableListView ลากจัดลำดับ
class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // AI-ASSISTED: รายการคุณสมบัติที่ต้องการในคู่
  List<PreferenceItem> _preferences = [
    PreferenceItem(
      id: 'humor',
      emoji: '😄',
      title: 'อารมณ์ขัน',
      description: 'คนที่ทำให้คุณหัวเราะได้',
    ),
    PreferenceItem(
      id: 'ambition',
      emoji: '💪',
      title: 'ความทะเยอทะยาน',
      description: 'คนที่มีเป้าหมายในชีวิต',
    ),
    PreferenceItem(
      id: 'honesty',
      emoji: '🤝',
      title: 'ความซื่อสัตย์',
      description: 'คนที่ไว้ใจได้',
    ),
    PreferenceItem(
      id: 'creativity',
      emoji: '🎨',
      title: 'ความคิดสร้างสรรค์',
      description: 'คนที่มีไอเดียแปลกใหม่',
    ),
    PreferenceItem(
      id: 'intelligence',
      emoji: '📚',
      title: 'ความฉลาด',
      description: 'คนที่ชอบเรียนรู้สิ่งใหม่',
    ),
    PreferenceItem(
      id: 'kindness',
      emoji: '💕',
      title: 'ความใจดี',
      description: 'คนที่มีน้ำใจ',
    ),
    PreferenceItem(
      id: 'adventure',
      emoji: '🌍',
      title: 'ชอบผจญภัย',
      description: 'คนที่ชอบท่องเที่ยว',
    ),
    PreferenceItem(
      id: 'stability',
      emoji: '🏠',
      title: 'ความมั่นคง',
      description: 'คนที่มีความมั่นคงในชีวิต',
    ),
  ];

  bool _isSaved = false;

  // AI-ASSISTED: ฟังก์ชันจัดการเมื่อลาก item ไปตำแหน่งใหม่
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _preferences.removeAt(oldIndex);
      _preferences.insert(newIndex, item);
      _isSaved = false;
    });
  }

  void _savePreferences() {
    setState(() {
      _isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('บันทึกลำดับความสำคัญสำเร็จ!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ My Preferences'),
        centerTitle: true,
        actions: [
          // AI-ASSISTED: Dark Mode Toggle
          IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: animation,
                  child: child,
                );
              },
              child: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(themeProvider.isDarkMode),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: colorScheme.primaryContainer.withOpacity(0.3),
            child: Column(
              children: [
                Icon(
                  Icons.drag_indicator,
                  color: colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'ลากจัดลำดับคุณสมบัติที่คุณต้องการ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'อันดับ 1 = สำคัญที่สุด',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // AI-ASSISTED: ReorderableListView สำหรับลากจัดลำดับ
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _preferences.length,
              onReorder: _onReorder,
              // AI-ASSISTED: ปิด default drag handles ทางขวา เพื่อใช้ custom ทางซ้าย
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) {
                final double elevation = Tween<double>(
                  begin: 0,
                  end: 8,
                ).evaluate(animation);
                return Material(
                  elevation: elevation,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black45,
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final item = _preferences[index];
                // AI-ASSISTED: ใช้ ValueKey กับ id ที่ unique เพื่อให้ Flutter track item ได้ถูกต้อง
                return _buildPreferenceItem(
                  key: ValueKey('preference_${item.id}'),
                  item: item,
                  index: index,
                  colorScheme: colorScheme,
                );
              },
            ),
          ),

          // AI-ASSISTED: ปุ่มบันทึกพร้อม Animation
          Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedButton(
              onPressed: _savePreferences,
              backgroundColor: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSaved ? Icons.check : Icons.save,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isSaved ? 'บันทึกแล้ว ✓' : 'บันทึก & หาคู่! 💕',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildPreferenceItem({
    required Key key,
    required PreferenceItem item,
    required int index,
    required ColorScheme colorScheme,
  }) {
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI-ASSISTED: ReorderableDragStartListener ทำให้ลากจาก icon ทางซ้ายได้
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_handle,
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(width: 12),
            // Rank Number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getRankColor(index),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              item.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        // AI-ASSISTED: แสดงดาวเฉพาะ 3 อันดับแรก
        trailing: index < 3
            ? Icon(
                Icons.star,
                color: _getRankColor(index),
              )
            : null,
      ),
    );
  }

  // AI-ASSISTED: กำหนดสีตามอันดับ (ทอง/เงิน/ทองแดง)
  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Gold
      case 1:
        return Colors.grey.shade400; // Silver
      case 2:
        return Colors.brown.shade400; // Bronze
      default:
        return Colors.blueGrey;
    }
  }
}
