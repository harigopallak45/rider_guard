import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/rg_button.dart';
import '../widgets/rg_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Hari Gopal Lak');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');
  final _bloodCtrl = TextEditingController(text: 'O+');
  final _notesCtrl = TextEditingController(text: 'No known allergies');
  bool _crashDetection = true;
  bool _outOfRange = true;
  bool _notifications = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bloodCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Profile saved!',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppTheme.accent.withOpacity(0.2),
                        AppTheme.accent.withOpacity(0.05),
                      ]),
                      border: Border.all(
                          color: AppTheme.accent.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(Icons.person_rounded,
                        size: 48, color: AppTheme.textSecondary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accent),
                      child: const Icon(Icons.edit_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _SectionLabel(label: 'Personal Info', icon: Icons.person_rounded),
            const SizedBox(height: 12),
            RgTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                icon: Icons.badge_rounded),
            const SizedBox(height: 12),
            RgTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 28),

            _SectionLabel(
                label: 'Medical Information',
                icon: Icons.medical_information_rounded),
            const SizedBox(height: 12),
            RgTextField(
                controller: _bloodCtrl,
                label: 'Blood Type',
                icon: Icons.water_drop_rounded),
            const SizedBox(height: 12),
            RgTextField(
                controller: _notesCtrl,
                label: 'Medical Notes',
                icon: Icons.note_rounded,
                maxLines: 3),
            const SizedBox(height: 28),

            _SectionLabel(
                label: 'Emergency Contacts',
                icon: Icons.contacts_rounded),
            const SizedBox(height: 12),
            _ContactEditorCard(name: 'Mom', phone: '+91 98765 43210'),
            const SizedBox(height: 8),
            _ContactEditorCard(name: 'Best Friend', phone: '+91 91234 56789'),
            const SizedBox(height: 8),
            _AddContactButton(),
            const SizedBox(height: 28),

            _SectionLabel(
                label: 'Safety Settings', icon: Icons.settings_rounded),
            const SizedBox(height: 12),
            _ToggleCard(
              icon: Icons.sensors_rounded,
              iconColor: AppTheme.teal,
              title: 'Crash Detection',
              subtitle: 'Auto-trigger SOS on impact',
              value: _crashDetection,
              onChanged: (v) => setState(() => _crashDetection = v),
            ),
            const SizedBox(height: 8),
            _ToggleCard(
              icon: Icons.radar_rounded,
              iconColor: AppTheme.amber,
              title: 'Out-of-Range Alert',
              subtitle: 'Alert if > 500m from group for 30s',
              value: _outOfRange,
              onChanged: (v) => setState(() => _outOfRange = v),
            ),
            const SizedBox(height: 8),
            _ToggleCard(
              icon: Icons.notifications_rounded,
              iconColor: AppTheme.blue,
              title: 'Push Notifications',
              subtitle: 'Receive SOS and trip alerts',
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            const SizedBox(height: 32),

            RgButton(
                label: 'SAVE PROFILE',
                isLoading: _isSaving,
                onPressed: _save),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Sign Out',
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.accent),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 1)),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: AppTheme.border, height: 1)),
      ],
    );
  }
}

class _ContactEditorCard extends StatelessWidget {
  final String name;
  final String phone;
  const _ContactEditorCard({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent.withOpacity(0.1),
            ),
            child: const Icon(Icons.person_rounded,
                color: AppTheme.accent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        fontSize: 14)),
                Text(phone,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded,
              size: 16, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}

class _AddContactButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppTheme.accent.withOpacity(0.3),
              style: BorderStyle.solid),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppTheme.accent, size: 20),
            SizedBox(width: 8),
            Text('Add Emergency Contact',
                style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: iconColor,
          ),
        ],
      ),
    );
  }
}
