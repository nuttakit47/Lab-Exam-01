// AI-ASSISTED: Model สำหรับคุณสมบัติที่ต้องการในคู่
// ใช้ใน ReorderableListView
class PreferenceItem {
  final String id;      // AI-ASSISTED: ID ที่ unique สำหรับใช้เป็น Key
  final String emoji;   // Emoji แสดงคุณสมบัติ
  final String title;   // ชื่อคุณสมบัติ
  final String description; // คำอธิบาย

  PreferenceItem({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
  });

  // ใช้สำหรับ copy พร้อมเปลี่ยนค่าบางตัว
  PreferenceItem copyWith({
    String? id,
    String? emoji,
    String? title,
    String? description,
  }) {
    return PreferenceItem(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PreferenceItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PreferenceItem(id: $id, emoji: $emoji, title: $title)';
  }
}
