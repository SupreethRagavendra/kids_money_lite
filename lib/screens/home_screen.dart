import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/money_provider.dart';
import 'piggy_bank_screen.dart';
import 'challenges_screen.dart';
import 'goal_screen.dart';
import 'store_screen.dart';
import 'parent_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);
    final mood = moneyProvider.currentMood;
    final message = moneyProvider.aiMessage;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("My Money World"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ParentView()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // AI Watcher Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildMoodIcon(mood),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Money Watcher says:",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: -0.5, end: 0, duration: 500.ms),
            
            const SizedBox(height: 24),
            
            // Main Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  _HomeButton(
                    title: "Piggy Bank",
                    icon: Icons.savings_rounded,
                    color: const Color(0xFFFF6B6B),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PiggyBankScreen())),
                  ),
                  _HomeButton(
                    title: "Challenges",
                    icon: Icons.star_rounded,
                    color: const Color(0xFFFFD93D),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengesScreen())),
                  ),
                  _HomeButton(
                    title: "My Goals",
                    icon: Icons.flag_rounded,
                    color: const Color(0xFF6BCB77),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalScreen())),
                  ),
                  _HomeButton(
                    title: "Store",
                    icon: Icons.store_rounded,
                    color: const Color(0xFF4D96FF),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIcon(AiMood mood) {
    IconData icon;
    Color color;
    switch (mood) {
      case AiMood.happy:
        icon = Icons.sentiment_very_satisfied_rounded;
        color = Colors.green;
        break;
      case AiMood.sad:
        icon = Icons.sentiment_very_dissatisfied_rounded;
        color = Colors.red;
        break;
      case AiMood.giving:
        icon = Icons.volunteer_activism_rounded;
        color = Colors.pink;
        break;
      default:
        icon = Icons.sentiment_satisfied_rounded;
        color = Colors.blue;
    }
    return Icon(icon, size: 50, color: color)
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds);
  }
}

class _HomeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
  }
}
