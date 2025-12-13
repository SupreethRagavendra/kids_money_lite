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
      title: 'Meet Penny!',
      subtitle: 'Your Magical Savings Friend',
      imagePath: 'assets/images/piggy_hero.png',
      description: 'Penny will help you become a savings superstar!',
      gradientColors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
      particleEmojis: ['💖', '✨', '🌟', '💫', '🦋'],
    ),
    SplashPageData(
      title: 'Collect Treasure!',
      subtitle: 'Watch Your Coins Grow',
      imagePath: 'assets/images/treasure.png',
      description: 'Save coins and build your magical treasure chest!',
      gradientColors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
      particleEmojis: ['💰', '💎', '👑', '🪙', '⭐'],
    ),
    SplashPageData(
      title: 'Reach Your Dreams!',
      subtitle: 'Set Goals & Win Rewards',
      imagePath: 'assets/images/trophy.png',
      description: 'Complete challenges and earn amazing badges!',
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      particleEmojis: ['🏆', '🎉', '🥇', '🎊', '🌈'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoAdvance();
  }

  void _autoAdvance() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        if (_currentPage < _pages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
          _autoAdvance();
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) _navigateToHome();
          });
        }
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
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
            itemBuilder: (context, index) => _PremiumSplashPage(
              data: _pages[index],
              isActive: _currentPage == index,
            ),
          ),

          // Skip Button
          Positioned(
            top: 40,
            right: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _navigateToHome,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Skip →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),
            ),
          ),

          // Bottom section
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Get Started Button (on last page)
                  if (_currentPage == _pages.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ElevatedButton(
                        onPressed: _navigateToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _pages[_currentPage].gradientColors[0],
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 8,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Let's Go!",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Text('🚀', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.3),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashPageData {
  final String title;
  final String subtitle;
  final String imagePath;
  final String description;
  final List<Color> gradientColors;
  final List<String> particleEmojis;

  SplashPageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.description,
    required this.gradientColors,
    required this.particleEmojis,
  });
}

class _PremiumSplashPage extends StatelessWidget {
  final SplashPageData data;
  final bool isActive;

  const _PremiumSplashPage({required this.data, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: data.gradientColors,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Hero Image
              Expanded(
                flex: 5,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        data.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.savings, size: 80, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                      .animate(target: isActive ? 1 : 0)
                      .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(),
                ),
              ),

              // Text content
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, offset: Offset(1, 2), blurRadius: 4)],
                      ),
                    ).animate(target: isActive ? 1 : 0).fadeIn(delay: 200.ms).slideY(begin: 0.2),

                    const SizedBox(height: 8),

                    Text(
                      data.subtitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ).animate(target: isActive ? 1 : 0).fadeIn(delay: 350.ms),

                    const SizedBox(height: 12),

                    Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                    ).animate(target: isActive ? 1 : 0).fadeIn(delay: 500.ms),

                    const SizedBox(height: 16),

                    // Emoji row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: data.particleEmojis.take(3).toList().asMap().entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(e.value, style: const TextStyle(fontSize: 28))
                              .animate(target: isActive ? 1 : 0, delay: (600 + e.key * 100).ms)
                              .fadeIn()
                              .scale(curve: Curves.elasticOut),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60), // Space for bottom UI
            ],
          ),
        ),
      ),
    );
  }
}
