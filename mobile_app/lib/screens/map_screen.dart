import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/countdown_dialog.dart';

class MapScreen extends StatefulWidget {
  final String tripId;
  final String tripName;
  final bool isCreator;

  const MapScreen({
    super.key,
    required this.tripId,
    required this.tripName,
    this.isCreator = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;
  bool _isTracking = true;
  int _riderCount = 3;

  // Mock rider data for demo
  final List<_MockRider> _riders = [
    _MockRider('You', 0.0, 0.0, Colors.teal, online: true),
    _MockRider('Vikram', 0.3, 0.2, Colors.blue, online: true),
    _MockRider('Priya', -0.15, 0.4, Colors.purple, online: true),
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        lowerBound: 0.7,
        upperBound: 1.0)
      ..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _simulateCrash() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CountdownDialog(),
    );
    if (result == true && mounted) {
      Navigator.pushReplacementNamed(context, '/emergency');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mock Map Background (placeholder when google_maps not configured)
          _MockMapBackground(riders: _riders),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _TopBar(
                tripId: widget.tripId,
                tripName: widget.tripName,
                riderCount: _riderCount,
                onBack: () => Navigator.pop(context),
              ),
            ),
          ),

          // Right panel: Riders online
          Positioned(
            top: 120,
            right: 16,
            child: SafeArea(child: _RidersPanel(riders: _riders)),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomPanel(
              isTracking: _isTracking,
              onCenterMap: () {},
              onToggleTracking: () =>
                  setState(() => _isTracking = !_isTracking),
              onSimulateCrash: _simulateCrash,
              pulse: _pulse,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String tripId;
  final String tripName;
  final int riderCount;
  final VoidCallback onBack;

  const _TopBar({
    required this.tripId,
    required this.tripName,
    required this.riderCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_rounded,
                  color: AppTheme.textPrimary, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tripName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textPrimary)),
                Text('Code: $tripId',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1)),
              ],
            ),
          ),
          // Live indicator
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppTheme.teal.withOpacity(0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.teal,
                  ),
                ),
                const SizedBox(width: 6),
                Text('$riderCount LIVE',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.teal,
                        letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RidersPanel extends StatelessWidget {
  final List<_MockRider> riders;
  const _RidersPanel({required this.riders});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: riders.map((r) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: r.color.withOpacity(0.2),
                  child: Icon(Icons.two_wheeler_rounded,
                      size: 12, color: r.color),
                ),
                const SizedBox(width: 8),
                Text(r.name,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onCenterMap;
  final VoidCallback onToggleTracking;
  final VoidCallback onSimulateCrash;
  final Animation<double> pulse;

  const _BottomPanel({
    required this.isTracking,
    required this.onCenterMap,
    required this.onToggleTracking,
    required this.onSimulateCrash,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withOpacity(0.97),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: const Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, -10))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _ControlButton(
                  icon: Icons.my_location_rounded,
                  label: 'Centre',
                  onTap: onCenterMap,
                  color: AppTheme.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ControlButton(
                  icon: isTracking
                      ? Icons.sensors_rounded
                      : Icons.sensors_off_rounded,
                  label: isTracking ? 'Tracking' : 'Paused',
                  onTap: onToggleTracking,
                  color: isTracking ? AppTheme.teal : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Crash SImulate button (prominent for demo)
          GestureDetector(
            onTap: onSimulateCrash,
            child: AnimatedBuilder(
              animation: pulse,
              builder: (_, child) => Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF3B3B), Color(0xFFC62828)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent
                          .withOpacity(0.4 * pulse.value),
                      blurRadius: 30,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'SIMULATE CRASH DETECTION',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────
// Mock Map — replace with GoogleMap widget once API key is added
// ────────────────────────────────────────────────────────
class _MockMapBackground extends StatelessWidget {
  final List<_MockRider> riders;
  const _MockMapBackground({required this.riders});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Container(
      width: sz.width,
      height: sz.height,
      color: const Color(0xFF1A1A2E),
      child: CustomPaint(
        painter: _MapGridPainter(),
        child: Stack(
          alignment: Alignment.center,
          children: riders.asMap().entries.map((e) {
            final i = e.key;
            final r = e.value;
            return Positioned(
              top: sz.height * 0.45 + r.offsetY * 60,
              left: sz.width * 0.5 + r.offsetX * 60 - 22,
              child: _RiderDot(rider: r, isYou: i == 0),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2A45)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Fake roads
    final roadPaint = Paint()
      ..color = const Color(0xFF34345A)
      ..strokeWidth = 8;
    canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.3),
        Offset(size.width, size.height * 0.6),
        roadPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RiderDot extends StatelessWidget {
  final _MockRider rider;
  final bool isYou;
  const _RiderDot({required this.rider, required this.isYou});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: rider.color,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                  color: rider.color.withOpacity(0.5),
                  blurRadius: 16,
                  spreadRadius: 2),
            ],
          ),
          child: Icon(
            isYou ? Icons.person_pin_rounded : Icons.two_wheeler_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.bgCard.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: rider.color.withOpacity(0.5)),
          ),
          child: Text(rider.name,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ],
    );
  }
}

class _MockRider {
  final String name;
  final double offsetX;
  final double offsetY;
  final Color color;
  final bool online;

  const _MockRider(this.name, this.offsetX, this.offsetY, this.color,
      {this.online = true});
}
