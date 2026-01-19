import 'package:flutter/material.dart';

// AI-ASSISTED: AnimatedButton - ปุ่มที่มี Animation เมื่อกด
// ใช้ ScaleTransition และ AnimatedContainer
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  // AI-ASSISTED: AnimationController สำหรับควบคุม animation
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // AI-ASSISTED: ScaleTransition ย่อปุ่มเมื่อกด
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = widget.backgroundColor ?? colorScheme.primary;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      // AI-ASSISTED: ScaleTransition ทำให้ปุ่มย่อเมื่อกด
      child: ScaleTransition(
        scale: _scaleAnimation,
        // AI-ASSISTED: AnimatedContainer เปลี่ยนสีและเงาเมื่อกด
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width ?? double.infinity,
          height: widget.height ?? 56,
          decoration: BoxDecoration(
            color: _isPressed ? bgColor.withOpacity(0.8) : bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(_isPressed ? 0.2 : 0.4),
                blurRadius: _isPressed ? 4 : 8,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

// AI-ASSISTED: AnimatedIconButton - ปุ่ม icon ที่มี animation
class AnimatedIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final double size;
  final String? tooltip;

  const AnimatedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.size = 24,
    this.tooltip,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        onPressed: _onTap,
        icon: Icon(widget.icon),
        color: widget.color,
        iconSize: widget.size,
        tooltip: widget.tooltip,
      ),
    );
  }
}
