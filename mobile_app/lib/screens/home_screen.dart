import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/sos_button.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  bool _sensorsActive = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SOS Button
                    SosButton(onPressed: () {
                      Navigator.pushNamed(context, '/emergency');
                    }),
                    const SizedBox(height: 32),

                    // Stats Row
                    const _SectionHeader(title: 'Live Status'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.sensors_rounded,
                            label: 'Crash Sensor',
                            value: _sensorsActive ? 'ACTIVE' : 'OFF',
                            valueColor: _sensorsActive
                                ? AppTheme.teal
                                : AppTheme.textSecondary,
                            accent: AppTheme.teal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: StatCard(
                            icon: Icons.location_on_rounded,
                            label: 'GPS',
                            value: 'LOCKED',
                            valueColor: AppTheme.blue,
                            accent: AppTheme.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: StatCard(
                            icon: Icons.people_rounded,
                            label: 'Riders',
                            value: '1',
                            valueColor: AppTheme.amber,
                            accent: AppTheme.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Group Ride Section
                    const _SectionHeader(title: 'Group Ride'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _TripActionCard(
                            title: 'Create Trip',
                            subtitle: 'Start a group ride',
                            icon: Icons.add_road_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1A2A4A), Color(0xFF0D1525)],
                            ),
                            borderColor: AppTheme.blue,
                            iconColor: AppTheme.blue,
                            onTap: () {
                              Navigator.pushNamed(context, '/create-trip');
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TripActionCard(
                            title: 'Join Trip',
                            subtitle: 'Enter a trip code',
                            icon: Icons.group_add_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0D2A2A), Color(0xFF071515)],
                            ),
                            borderColor: AppTheme.teal,
                            iconColor: AppTheme.teal,
                            onTap: () {
                              Navigator.pushNamed(context, '/join-trip');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Safety Info Section
                    const _SectionHeader(title: 'Your Safety Profile'),
                    const SizedBox(height: 12),
                    _SafetyCard(),

                    const SizedBox(height: 24),

                    // Emergency Contacts
                    const _SectionHeader(title: 'Emergency Contacts'),
                    const SizedBox(height: 12),
                    _ContactsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.bgDark,
      title: Row(
        children: [
          const Icon(Icons.shield_rounded, color: AppTheme.accent, size: 22),
          const SizedBox(width: 10),
          const Text('Ride Guard',
              style:
                  TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border, width: 1.5),
              ),
              child: const CircleAvatar(
                radius: 17,
                backgroundColor: AppTheme.bgSurface,
                child: Icon(Icons.person_rounded,
                    size: 20, color: AppTheme.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: 0.3)),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: AppTheme.border, height: 1)),
      ],
    );
  }
}

class _TripActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _TripActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
                color: borderColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: const [
          _SafetyRow(label: 'Name', value: 'Hari Gopal Lak'),
          Divider(color: AppTheme.border, height: 24),
          _SafetyRow(label: 'Blood Type', value: 'O+'),
          Divider(color: AppTheme.border, height: 24),
          _SafetyRow(label: 'Medical Notes', value: 'No known allergies'),
        ],
      ),
    );
  }
}

class _SafetyRow extends StatelessWidget {
  final String label;
  final String value;
  const _SafetyRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppTheme.textSecondary)),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
      ],
    );
  }
}

class _ContactsList extends StatelessWidget {
  final List<Map<String, String>> contacts = const [
    {'name': 'Mom', 'phone': '+91 98765 43210'},
    {'name': 'Best Friend', 'phone': '+91 91234 56789'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: contacts.asMap().entries.map((e) {
          final isLast = e.key == contacts.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accent.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: AppTheme.accent, size: 20),
                ),
                title: Text(e.value['name']!,
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                subtitle: Text(e.value['phone']!,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
                trailing: const Icon(Icons.call_rounded,
                    color: AppTheme.teal, size: 20),
              ),
              if (!isLast)
                const Divider(
                    color: AppTheme.border, height: 1, indent: 72),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded), label: 'Trips'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
        onTap: (i) {
          if (i == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
