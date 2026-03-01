import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/rg_button.dart';
import '../widgets/rg_text_field.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _nameCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  bool _isLoading = false;
  String? _generatedCode;

  void _createTrip() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a trip name')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _generatedCode = 'RG-${DateTime.now().millisecondsSinceEpoch % 9999}';
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Trip')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            RgTextField(
              controller: _nameCtrl,
              label: 'Trip Name',
              hint: 'e.g. Sunday Highway Ride',
              icon: Icons.drive_file_rename_outline_rounded,
            ),
            const SizedBox(height: 16),
            RgTextField(
              controller: _destCtrl,
              label: 'Destination (Optional)',
              hint: 'e.g. Ooty, Tamil Nadu',
              icon: Icons.location_on_rounded,
            ),
            const SizedBox(height: 32),

            if (_generatedCode == null)
              RgButton(
                label: 'GENERATE TRIP CODE',
                isLoading: _isLoading,
                onPressed: _createTrip,
              )
            else ...[
              _buildCodeCard(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/map',
                    arguments: {
                      'tripId': _generatedCode,
                      'tripName': _nameCtrl.text.trim(),
                      'isCreator': true,
                    },
                  );
                },
                child: const Text('START TRACKING'),
              ),
            ],

            const SizedBox(height: 32),
            _buildTipBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.add_road_rounded,
              color: AppTheme.blue, size: 30),
        ),
        const SizedBox(height: 16),
        const Text('New Group Ride',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Create a trip and share the code with your riding buddies. Everyone\'s location will be visible on the map.',
          style: TextStyle(color: AppTheme.textSecondary, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildCodeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2040), Color(0xFF061020)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.blue.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: AppTheme.blue.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          const Text('Your Trip Code',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 12),
          Text(
            _generatedCode!,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
              color: AppTheme.blue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              const Text('Share this code with your group',
                  style:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.amber.withOpacity(0.2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates_rounded,
              color: AppTheme.amber, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Crash detection runs automatically in the background. If an impact is detected, a 15-second countdown will start before alerting your group.',
              style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
