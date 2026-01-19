import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../models/match_profile.dart';
import '../widgets/animated_button.dart';

// AI-ASSISTED: หน้า Matches ใช้ Dismissible ปัด 2 ทาง และมี Search/Filter
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with TickerProviderStateMixin {
  // AI-ASSISTED: รายการคนที่ Match (ข้อมูลจำลอง)
  List<MatchProfile> _matches = [
    MatchProfile(
      id: '1',
      name: 'มิ้นท์',
      age: 24,
      avatar: '👩',
      bio: 'ชอบอ่านหนังสือ, ดูหนัง, ฟังเพลง',
      matchPercent: 92,
      interests: ['หนังสือ', 'หนัง', 'เพลง'],
    ),
    MatchProfile(
      id: '2',
      name: 'เบล',
      age: 22,
      avatar: '👩‍🦰',
      bio: 'ชอบเที่ยว, ทำอาหาร, ถ่ายรูป',
      matchPercent: 87,
      interests: ['ท่องเที่ยว', 'อาหาร', 'ถ่ายรูป'],
    ),
    MatchProfile(
      id: '3',
      name: 'พลอย',
      age: 25,
      avatar: '👩‍🦱',
      bio: 'ชอบดนตรี, กีฬา, วาดรูป',
      matchPercent: 81,
      interests: ['ดนตรี', 'กีฬา', 'ศิลปะ'],
    ),
    MatchProfile(
      id: '4',
      name: 'แอน',
      age: 23,
      avatar: '👱‍♀️',
      bio: 'ชอบโยคะ, อ่านหนังสือ, ทำสวน',
      matchPercent: 78,
      interests: ['โยคะ', 'หนังสือ', 'ธรรมชาติ'],
    ),
    MatchProfile(
      id: '5',
      name: 'นุ่น',
      age: 26,
      avatar: '👩‍🎤',
      bio: 'ชอบร้องเพลง, เต้น, แต่งหน้า',
      matchPercent: 75,
      interests: ['ร้องเพลง', 'เต้น', 'แฟชั่น'],
    ),
    MatchProfile(
      id: '6',
      name: 'ฝ้าย',
      age: 24,
      avatar: '👩‍💼',
      bio: 'ชอบทำงาน, อ่านข่าว, ดูซีรีส์',
      matchPercent: 72,
      interests: ['ธุรกิจ', 'ข่าว', 'ซีรีส์'],
    ),
  ];

  // AI-ASSISTED: Search & Filter state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterOption = 'ทั้งหมด';
  final List<String> _filterOptions = ['ทั้งหมด', '80%+', '70-79%', 'ไลค์แล้ว'];

  // AI-ASSISTED: เก็บรายการที่กดไลค์
  final Set<String> _likedIds = {};

  // เก็บ item ที่เพิ่งลบ (สำหรับ undo)
  MatchProfile? _lastDismissed;
  int? _lastDismissedIndex;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // AI-ASSISTED: กรองรายการตาม search query และ filter option
  List<MatchProfile> get _filteredMatches {
    return _matches.where((match) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          match.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          match.bio.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          match.interests.any((interest) =>
              interest.toLowerCase().contains(_searchQuery.toLowerCase()));

      // Filter by option
      bool matchesFilter = true;
      switch (_filterOption) {
        case '80%+':
          matchesFilter = match.matchPercent >= 80;
          break;
        case '70-79%':
          matchesFilter =
              match.matchPercent >= 70 && match.matchPercent < 80;
          break;
        case 'ไลค์แล้ว':
          matchesFilter = _likedIds.contains(match.id);
          break;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // AI-ASSISTED: จัดการเมื่อปัดซ้าย (Pass) - ลบออกจากรายการ
  void _handlePass(MatchProfile match) {
    final originalIndex = _matches.indexOf(match);

    setState(() {
      _lastDismissed = match;
      _lastDismissedIndex = originalIndex;
      _matches.removeAt(originalIndex);
    });

    _showSnackBar('❌ Pass ${match.name}', canUndo: true);
  }

  // AI-ASSISTED: undo การลบ
  void _undoLastDismiss() {
    if (_lastDismissed != null && _lastDismissedIndex != null) {
      setState(() {
        _matches.insert(_lastDismissedIndex!, _lastDismissed!);
        _lastDismissed = null;
        _lastDismissedIndex = null;
      });
    }
  }

  void _showSnackBar(String message, {bool isLike = false, bool canUndo = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isLike ? Colors.pink : Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: canUndo
            ? SnackBarAction(
                label: 'ยกเลิก',
                textColor: Colors.white,
                onPressed: _undoLastDismiss,
              )
            : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final filteredMatches = _filteredMatches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💕 Matches'),
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
          // AI-ASSISTED: Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อ หรือความสนใจ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // AI-ASSISTED: Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filterOptions.map((option) {
                final isSelected = _filterOption == option;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _filterOption = option;
                      });
                    },
                    selectedColor: colorScheme.primaryContainer,
                    checkmarkColor: colorScheme.primary,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Swipe Hint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSwipeHint(
                  icon: Icons.arrow_back,
                  text: 'ปัดซ้าย = Pass',
                  color: Colors.red,
                ),
                _buildSwipeHint(
                  icon: Icons.arrow_forward,
                  text: 'ปัดขวา = Like',
                  color: Colors.green,
                ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'พบ ${filteredMatches.length} คน',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                if (_likedIds.isNotEmpty)
                  Text(
                    '💕 ไลค์แล้ว ${_likedIds.length} คน',
                    style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // AI-ASSISTED: Match List with Dismissible ปัด 2 ทาง
          Expanded(
            child: filteredMatches.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredMatches.length,
                    itemBuilder: (context, index) {
                      final match = filteredMatches[index];
                      final isLiked = _likedIds.contains(match.id);

                      // AI-ASSISTED: Dismissible พร้อม ValueKey ที่ unique
                      return Dismissible(
                        // AI-ASSISTED: ใช้ ValueKey กับ id ที่ unique เพื่อระบุ item ที่ถูกลบ
                        key: ValueKey('match_${match.id}'),
                        // AI-ASSISTED: ปัดได้ 2 ทาง
                        direction: DismissDirection.horizontal,
                        // AI-ASSISTED: Background เมื่อปัดขวา (Like) - สีเขียว
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.white, size: 32),
                              SizedBox(width: 8),
                              Text(
                                'Like',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // AI-ASSISTED: Background เมื่อปัดซ้าย (Pass) - สีแดง
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Pass',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.close, color: Colors.white, size: 32),
                            ],
                          ),
                        ),
                        // AI-ASSISTED: confirmDismiss ใช้ตัดสินใจว่าจะลบหรือไม่
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // AI-ASSISTED: ปัดขวา = Like (ไม่ลบ แค่เพิ่มเข้า liked)
                            setState(() {
                              _likedIds.add(match.id);
                            });
                            _showSnackBar('💕 Liked ${match.name}!', isLike: true);
                            return false; // return false เพื่อไม่ให้ลบออก
                          }
                          // AI-ASSISTED: ปัดซ้าย = Pass (ลบออก)
                          return true; // return true เพื่อให้ลบออก
                        },
                        // AI-ASSISTED: onDismissed ทำงานเมื่อ confirmDismiss return true
                        onDismissed: (direction) {
                          _handlePass(match);
                        },
                        child: _buildMatchCard(match, isLiked, colorScheme),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeHint({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // AI-ASSISTED: สร้าง Card แสดงข้อมูลคนที่ Match
  Widget _buildMatchCard(
    MatchProfile match,
    bool isLiked,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isLiked
            ? const BorderSide(color: Colors.pink, width: 2)
            : BorderSide.none,
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      match.avatar,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${match.name}, ${match.age}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (isLiked) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.bio,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Match Percent
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getMatchColor(match.matchPercent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${match.matchPercent}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Interests
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: match.interests.map((interest) {
                return Chip(
                  label: Text(
                    interest,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบผลลัพธ์',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ลองเปลี่ยนคำค้นหาหรือตัวกรอง',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _filterOption = 'ทั้งหมด';
              });
            },
            backgroundColor: Colors.grey,
            child: const Text(
              'ล้างตัวกรอง',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(int percent) {
    if (percent >= 85) return Colors.green;
    if (percent >= 75) return Colors.orange;
    return Colors.blue;
  }
}
