import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class CountdownDialog extends StatefulWidget {
  const CountdownDialog({super.key});

  @override
  State<CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog>
    with TickerProviderStateMixin {
  static const _totalSeconds = 15;
  int _remaining = _totalSeconds;
  Timer? _timer;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeCtrl.forward();

    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
        lowerBound: 0.9,
        upperBound: 1.08)
      ..repeat(reverse: true);

    _pulseAnim =
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remaining <= 1) {
        t.cancel();
        Navigator.pop(context, true);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _cancel() {
    _timer?.cancel();
    Navigator.pop(context, false);
  }

  void _sendNow() {
    _timer?.cancel();
    Navigator.pop(context, true);
  }

  Color get _countColor {
    if (_remaining > 10) return Colors.white;
    if (_remaining > 5) return AppTheme.amber;
    return AppTheme.accent;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / _totalSeconds;

    return FadeTransition(
      opacity: _fadeCtrl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: AppTheme.accent.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.accent.withOpacity(0.25),
                  blurRadius: 50,
                  spreadRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: AppTheme.accent, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CRASH DETECTED',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.accent,
                              letterSpacing: 1.5)),
                      Text('Impact threshold exceeded',
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Progress Ring + Countdown Number
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow behind ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _countColor.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                    ),
                    // Progress ring
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: AppTheme.border,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_countColor),
                      ),
                    ),
                    // Number
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _pulseAnim.value,
                        child: child,
                      ),
                      child: Text(
                        '$_remaining',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: _countColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Sending SOS alert to your group\nand emergency contacts',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.textSecondary, height: 1.6, fontSize: 14),
              ),
              const SizedBox(height: 28),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _cancel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.bgSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.check_circle_outline_rounded,
                                color: AppTheme.teal, size: 22),
                            SizedBox(height: 4),
                            Text("I'M OKAY",
                                style: TextStyle(
                                    color: AppTheme.teal,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _sendNow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF3B3B), Color(0xFFB71C1C)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: AppTheme.accent.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.send_rounded,
                                color: Colors.white, size: 22),
                            SizedBox(height: 4),
                            Text('SEND NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
