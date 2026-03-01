import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_trip_screen.dart';
import 'screens/join_trip_screen.dart';
import 'screens/map_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const RideGuardApp());
}

class RideGuardApp extends StatelessWidget {
  const RideGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Guard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return _fadeRoute(const SplashScreen(), settings);
          case '/login':
            return _fadeRoute(const LoginScreen(), settings);
          case '/home':
            return _fadeRoute(const HomeScreen(), settings);
          case '/create-trip':
            return _slideRoute(const CreateTripScreen(), settings);
          case '/join-trip':
            return _slideRoute(const JoinTripScreen(), settings);
          case '/profile':
            return _slideRoute(const ProfileScreen(), settings);
          case '/map':
            final args = settings.arguments as Map<String, dynamic>?;
            return _fadeRoute(
              MapScreen(
                tripId: args?['tripId'] ?? 'DEMO-1234',
                tripName: args?['tripName'] ?? 'Demo Ride',
                isCreator: args?['isCreator'] ?? false,
              ),
              settings,
            );
          case '/emergency':
            return _fadeRoute(const EmergencyScreen(), settings);
          default:
            return _fadeRoute(const SplashScreen(), settings);
        }
      },
    );
  }

  PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

class AppTheme {
  // Color Tokens
  static const Color bgDark = Color(0xFF0A0A0F);
  static const Color bgCard = Color(0xFF14141C);
  static const Color bgSurface = Color(0xFF1C1C28);
  static const Color accent = Color(0xFFFF3B3B); // safety red
  static const Color accentGlow = Color(0x44FF3B3B);
  static const Color amber = Color(0xFFFFB800);
  static const Color teal = Color(0xFF00D4AA);
  static const Color blue = Color(0xFF4A90FF);
  static const Color textPrimary = Color(0xFFF2F2F7);
  static const Color textSecondary = Color(0xFF8E8EA0);
  static const Color border = Color(0xFF2C2C3E);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDark,
        primaryColor: accent,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: amber,
          surface: bgCard,
          onPrimary: Colors.white,
          onSurface: textPrimary,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: textPrimary),
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: textPrimary, fontSize: 34, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(
              color: textPrimary, fontSize: 24, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(
              color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
          bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: bgSurface,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: border, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: accent, width: 2)),
          labelStyle: const TextStyle(color: textSecondary),
          hintStyle:
              const TextStyle(color: textSecondary, fontStyle: FontStyle.italic),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          prefixIconColor: textSecondary,
        ),
      );
}
