import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _entranceCtrl;
  late Animation<double> _pulse;
  late Animation<double> _fade;
  late Animation<double> _slideY;

  bool _notified = false;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
        lowerBound: 0.85,
        upperBound: 1.0)
      ..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: _entranceCtrl, curve: Curves.easeIn));
    _slideY = Tween<double>(begin: 40, end: 0).animate(CurvedAnimation(
        parent: _entranceCtrl, curve: Curves.easeOutCubic));
    _entranceCtrl.forward();

    // Mark as notified shortly after entering
    Timer(const Duration(milliseconds: 600),
        () => setState(() => _notified = true));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0005),
      body: AnimatedBuilder(
        animation: _entranceCtrl,
        builder: (_, child) => Opacity(
          opacity: _fade.value,
          child: Transform.translate(
              offset: Offset(0, _slideY.value), child: child),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status header
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: AppTheme.accent.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('EMERGENCY MODE ACTIVE',
                          style: TextStyle(
                              color: AppTheme.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2)),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Pulsing SOS Icon
                Center(
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) => Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow rings
                        Container(
                          width: 220 * _pulse.value,
                          height: 220 * _pulse.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                AppTheme.accent.withOpacity(0.04 * _pulse.value),
                          ),
                        ),
                        Container(
                          width: 180 * _pulse.value,
                          height: 180 * _pulse.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                AppTheme.accent.withOpacity(0.07 * _pulse.value),
                          ),
                        ),
                        // Main circle
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFFFF3B3B), Color(0xFFB71C1C)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 10,
                              )
                            ],
                          ),
                          child: const Icon(Icons.sos_rounded,
                              color: Colors.white, size: 72),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'SOS ALERT SENT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Help is on the way.\nYour group and emergency contacts have been notified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFCCCCCC),
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),

                const Spacer(flex: 1),

                // Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0308),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppTheme.accent.withOpacity(0.2), width: 1),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                          icon: Icons.location_on_rounded,
                          label: 'Location',
                          value: '13.0827° N, 80.2707° E'),
                      const Divider(
                          color: Color(0xFF3A0A10), height: 24),
                      _InfoRow(
                          icon: Icons.water_drop_rounded,
                          label: 'Blood Type',
                          value: 'O+'),
                      const Divider(
                          color: Color(0xFF3A0A10), height: 24),
                      _InfoRow(
                          icon: Icons.people_rounded,
                          label: 'Notified',
                          value: _notified ? '3 riders + 2 contacts' : 'Sending…'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Status chips
                Row(children: [
                  _StatusChip(
                    icon: Icons.notifications_active_rounded,
                    label: 'Push Sent',
                    color: AppTheme.teal,
                    active: _notified,
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    icon: Icons.location_searching_rounded,
                    label: 'Live GPS',
                    color: AppTheme.blue,
                    active: true,
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    icon: Icons.medical_services_rounded,
                    label: 'Info Shared',
                    color: AppTheme.amber,
                    active: _notified,
                  ),
                ]),

                const SizedBox(height: 24),

                // Dismiss
                GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C28),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Text(
                      'DISMISS & RETURN HOME',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 18),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool active;

  const _StatusChip(
      {required this.icon,
      required this.label,
      required this.color,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.08) : AppTheme.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: active ? color.withOpacity(0.3) : AppTheme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16, color: active ? color : AppTheme.textSecondary),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: active ? color : AppTheme.textSecondary,
                )),
          ],
        ),
      ),
    );
  }
}
