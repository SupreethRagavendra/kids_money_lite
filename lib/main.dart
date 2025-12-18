import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/money_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/challenge_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const KidsMoneyLiteApp());
}

class KidsMoneyLiteApp extends StatelessWidget {
  const KidsMoneyLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoneyProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
      ],
      child: MaterialApp(
        title: 'Money Tree',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pinkAccent,
            brightness: Brightness.light,
            primary: const Color(0xFFFF6B6B), // Soft Red/Pink
            secondary: const Color(0xFFFFD93D), // Bright Yellow
            tertiary: const Color(0xFF6BCB77), // Soft Green
            background: const Color(0xFFFFF5F5), // Very light pink background
          ),
          textTheme: GoogleFonts.fredokaTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D4D4D),
            ),
            iconTheme: IconThemeData(color: Color(0xFF4D4D4D)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
