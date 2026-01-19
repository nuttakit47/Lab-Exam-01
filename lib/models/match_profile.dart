// AI-ASSISTED: Model สำหรับโปรไฟล์คนที่ Match
// ใช้ใน Dismissible ListView
class MatchProfile {
  final String id;          // AI-ASSISTED: ID ที่ unique สำหรับใช้เป็น Key ใน Dismissible
  final String name;        // ชื่อ
  final int age;            // อายุ
  final String avatar;      // Emoji avatar
  final String bio;         // ประโยคแนะนำตัว
  final int matchPercent;   // เปอร์เซ็นต์ความเข้ากันได้
  final List<String> interests; // ความสนใจ

  MatchProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatar,
    required this.bio,
    required this.matchPercent,
    required this.interests,
  });

  // ใช้สำหรับ copy พร้อมเปลี่ยนค่าบางตัว
  MatchProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? avatar,
    String? bio,
    int? matchPercent,
    List<String>? interests,
  }) {
    return MatchProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      matchPercent: matchPercent ?? this.matchPercent,
      interests: interests ?? this.interests,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MatchProfile(id: $id, name: $name, age: $age, matchPercent: $matchPercent%)';
  }
}
