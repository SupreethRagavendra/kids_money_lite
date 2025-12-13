import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<SplashPageData> _pages = [
    SplashPageData(
      title: '🐷 Welcome!',
      subtitle: 'Meet Penny the Piggy Bank',
      emoji: '🐷',
      description: 'Your new best friend for saving money!',
      gradient: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
      decorEmojis: ['💰', '✨', '⭐'],
    ),
    SplashPageData(
      title: '💰 Save Coins',
      subtitle: 'Build your treasure!',
      emoji: '💰',
      description: 'Add coins to your piggy bank and watch it grow!',
      gradient: [Color(0xFFFFD700), Color(0xFFFFA500)],
      decorEmojis: ['🪙', '💎', '🏆'],
    ),
    SplashPageData(
      title: '🎯 Set Goals',
      subtitle: 'Dream big!',
      emoji: '🎯',
      description: 'Save for the things you really want!',
      gradient: [Color(0xFF98FB98), Color(0xFF32CD32)],
      decorEmojis: ['🎁', '🎮', '📚'],
    ),
    SplashPageData(
      title: '⭐ Win Rewards',
      subtitle: 'Complete challenges!',
      emoji: '🏆',
      description: 'Earn badges and stickers for being a super saver!',
      gradient: [Color(0xFF87CEEB), Color(0xFF4169E1)],
      decorEmojis: ['🥇', '🎉', '🌟'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoAdvance();
  }

  void _autoAdvance() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentPage < _pages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _autoAdvance();
        } else {
          // Go to home after last page
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _SplashPage(data: _pages[index]),
          ),

          // Page Indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ).animate(target: _currentPage == index ? 1 : 0)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
              }),
            ),
          ),

          // Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text(
                'Skip →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Get Started Button (on last page)
          if (_currentPage == _pages.length - 1)
            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _pages[_currentPage].gradient[1],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Let's Start! 🚀",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 1, end: 0),
            ),
        ],
      ),
    );
  }
}

class SplashPageData {
  final String title;
  final String subtitle;
  final String emoji;
  final String description;
  final List<Color> gradient;
  final List<String> decorEmojis;

  SplashPageData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.description,
    required this.gradient,
    required this.decorEmojis,
  });
}

class _SplashPage extends StatelessWidget {
  final SplashPageData data;

  const _SplashPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Floating decorations
            ...List.generate(8, (index) => _buildFloatingEmoji(index)),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main emoji with glow effect
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        data.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut)
                      .then()
                      .shimmer(duration: 2000.ms, color: Colors.white30),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 24),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 40),

                  // Decorative emojis row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: data.decorEmojis.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 40),
                        )
                            .animate(
                              delay: (800 + entry.key * 150).ms,
                              onPlay: (c) => c.repeat(reverse: true),
                            )
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.2, 1.2),
                              duration: 800.ms,
                            ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingEmoji(int index) {
    final positions = [
      [30.0, 80.0],
      [300.0, 120.0],
      [50.0, 250.0],
      [320.0, 300.0],
      [80.0, 450.0],
      [280.0, 500.0],
      [150.0, 600.0],
      [350.0, 650.0],
    ];

    final emojis = ['✨', '⭐', '💫', '🌟', '✨', '⭐', '💫', '🌟'];

    return Positioned(
      left: positions[index][0],
      top: positions[index][1],
      child: Text(
        emojis[index],
        style: TextStyle(fontSize: 16 + (index % 3) * 6.0),
      )
          .animate(
            delay: (index * 300).ms,
            onPlay: (c) => c.repeat(reverse: true),
          )
          .fadeIn()
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.3, 1.3),
            duration: (1500 + index * 200).ms,
          ),
    );
  }
}
