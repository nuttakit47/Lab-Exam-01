import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_button.dart';

// AI-ASSISTED: หน้า Profile Setup พร้อม Form และ Validation
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // AI-ASSISTED: GlobalKey สำหรับ Form - ใช้เพื่อ validate และ save form ทั้งหมด
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers สำหรับแต่ละ field
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // เก็บค่าที่บันทึกแล้ว
  String? _savedNickname;
  String? _savedAge;
  String? _savedEmail;
  String? _savedBio;
  bool _isProfileSaved = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // AI-ASSISTED: เรียก validate ทุก field ใน form ผ่าน GlobalKey
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _savedNickname = _nicknameController.text;
        _savedAge = _ageController.text;
        _savedEmail = _emailController.text;
        _savedBio = _bioController.text;
        _isProfileSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('บันทึกโปรไฟล์สำเร็จ!'),
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
  }

  // AI-ASSISTED: Validator สำหรับชื่อเล่น - ตรวจสอบความยาว 2-20 ตัวอักษร และไม่มีอักขระพิเศษ
  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกชื่อเล่น';
    }
    if (value.length < 2) {
      return 'ชื่อเล่นต้องมีอย่างน้อย 2 ตัวอักษร';
    }
    if (value.length > 20) {
      return 'ชื่อเล่นต้องไม่เกิน 20 ตัวอักษร';
    }
    if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'ชื่อเล่นไม่ควรมีตัวเลขหรืออักขระพิเศษ';
    }
    return null;
  }

  // AI-ASSISTED: Validator สำหรับอายุ - ตรวจสอบ 18-99 ปี
  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอายุ';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'กรุณากรอกตัวเลขเท่านั้น';
    }
    if (age < 18) {
      return 'คุณต้องมีอายุอย่างน้อย 18 ปี';
    }
    if (age > 99) {
      return 'กรุณากรอกอายุที่ถูกต้อง';
    }
    return null;
  }

  // AI-ASSISTED: Validator สำหรับอีเมล - ใช้ RegExp ตรวจสอบรูปแบบ
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    return null;
  }

  // AI-ASSISTED: Validator สำหรับ Bio - ตรวจสอบความยาว 10-200 ตัวอักษร
  String? _validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเขียนแนะนำตัว';
    }
    if (value.length < 10) {
      return 'แนะนำตัวต้องมีอย่างน้อย 10 ตัวอักษร';
    }
    if (value.length > 200) {
      return 'แนะนำตัวต้องไม่เกิน 200 ตัวอักษร';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Profile Setup'),
        centerTitle: true,
        actions: [
          // AI-ASSISTED: Dark Mode Toggle พร้อม AnimatedSwitcher
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
            tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        // AI-ASSISTED: Form widget พร้อม GlobalKey สำหรับ validation
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar placeholder
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: colorScheme.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // AI-ASSISTED: Field 1 - ชื่อเล่น พร้อม validator
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อเล่น',
                  hintText: 'พิมพ์ชื่อเล่นของคุณ',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: _validateNickname,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // AI-ASSISTED: Field 2 - อายุ พร้อม validator และ inputFormatter
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'อายุ',
                  hintText: 'กรอกอายุของคุณ',
                  prefixIcon: const Icon(Icons.cake_outlined),
                  suffixText: 'ปี',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateAge,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // AI-ASSISTED: Field 3 - อีเมล พร้อม validator
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  hintText: 'example@mail.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // AI-ASSISTED: Field 4 - แนะนำตัว พร้อม validator
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'แนะนำตัว',
                  hintText: 'บอกเล่าเกี่ยวกับตัวคุณ...',
                  prefixIcon: const Icon(Icons.edit_note),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  counterText: '${_bioController.text.length}/200',
                ),
                maxLines: 4,
                maxLength: 200,
                validator: _validateBio,
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: 24),

              // AI-ASSISTED: ปุ่มบันทึกพร้อม Animation
              AnimatedButton(
                onPressed: _saveProfile,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'บันทึกโปรไฟล์',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // แสดงข้อมูลที่บันทึกแล้ว
              if (_isProfileSaved) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ข้อมูลที่บันทึก',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('ชื่อเล่น', _savedNickname ?? ''),
                      _buildInfoRow('อายุ', '${_savedAge ?? ''} ปี'),
                      _buildInfoRow('อีเมล', _savedEmail ?? ''),
                      _buildInfoRow('แนะนำตัว', _savedBio ?? ''),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
