import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/rg_button.dart';
import '../widgets/rg_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slideY;
  late Animation<double> _fade;

  final TextEditingController _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _slideY = Tween<double>(begin: 60, end: 0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.accent.withOpacity(0.12),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.blue.withOpacity(0.07),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, child) => Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                    offset: Offset(0, _slideY.value), child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),

                    // Logo
                    Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppTheme.accent.withOpacity(0.3), width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: AppTheme.accent.withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5),
                          ],
                          gradient: RadialGradient(colors: [
                            AppTheme.accent.withOpacity(0.15),
                            Colors.transparent,
                          ]),
                        ),
                        child: const Icon(Icons.shield_rounded,
                            size: 46, color: AppTheme.accent),
                      ),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to keep riding safe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary),
                    ),

                    const Spacer(flex: 1),

                    // Phone input
                    RgTextField(
                      controller: _phoneCtrl,
                      label: 'Phone Number',
                      hint: '+91 99999 00000',
                      icon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    RgButton(
                      label: 'GET OTP',
                      isLoading: _isLoading,
                      onPressed: _login,
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(children: [
                      const Expanded(child: Divider(color: AppTheme.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR',
                            style: TextStyle(
                                color: AppTheme.textSecondary.withOpacity(0.7),
                                fontSize: 12,
                                letterSpacing: 2)),
                      ),
                      const Expanded(child: Divider(color: AppTheme.border)),
                    ]),
                    const SizedBox(height: 24),

                    // Google Sign In
                    _SocialButton(
                      label: 'Continue with Google',
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: AppTheme.blue,
                      onTap: _login,
                    ),
                    const SizedBox(height: 12),
                    _SocialButton(
                      label: 'Continue with Email',
                      icon: Icons.email_rounded,
                      iconColor: AppTheme.teal,
                      onTap: _login,
                    ),

                    const Spacer(flex: 2),

                    // Footer
                    const Center(
                      child: Text(
                        'Mahendra Engineering College\nDept. of Cyber Security — Ride Guard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5),
                      ),
                    ),
                    const SizedBox(height: 20),
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

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
