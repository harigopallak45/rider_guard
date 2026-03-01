import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/rg_button.dart';

class JoinTripScreen extends StatefulWidget {
  const JoinTripScreen({super.key});

  @override
  State<JoinTripScreen> createState() => _JoinTripScreenState();
}

class _JoinTripScreenState extends State<JoinTripScreen> {
  final _codeCtrl = TextEditingController();
  bool _isLoading = false;

  void _joinTrip() async {
    if (_codeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a trip code')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(
      context,
      '/map',
      arguments: {
        'tripId': _codeCtrl.text.toUpperCase().trim(),
        'tripName': 'Joined Ride',
        'isCreator': false,
      },
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Trip')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon + Title
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.teal.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppTheme.teal.withOpacity(0.25), width: 1.5),
                  ),
                  child: const Icon(Icons.group_add_rounded,
                      color: AppTheme.teal, size: 38),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Join a Group Ride',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Get the trip code from your group leader and enter it below.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: AppTheme.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Code input (large, prominent)
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.teal.withOpacity(0.3), width: 1.5),
                ),
                child: TextField(
                  controller: _codeCtrl,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontSize: 28,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.teal,
                  ),
                  decoration: InputDecoration(
                    hintText: 'RG-0000',
                    hintStyle: TextStyle(
                      fontSize: 28,
                      letterSpacing: 8,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary.withOpacity(0.3),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 24),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              RgButton(
                label: 'CONNECT & JOIN',
                isLoading: _isLoading,
                color: AppTheme.teal,
                onPressed: _joinTrip,
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _QuickInfo(
                      icon: Icons.location_on_rounded,
                      text: 'Your GPS location will be shared with the group',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickInfo(
                      icon: Icons.sensors_rounded,
                      text: 'Crash detection activates automatically',
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

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _QuickInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.teal, size: 22),
          const SizedBox(height: 8),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }
}
