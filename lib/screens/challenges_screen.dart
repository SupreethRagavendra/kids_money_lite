import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/challenge_provider.dart';
import '../providers/money_provider.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4), // Light yellow
      appBar: AppBar(
        title: const Text("Daily Challenges"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Complete tasks to earn coins!",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: challengeProvider.challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challengeProvider.challenges[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                        height: challenge.isCompleted ? 50 : 40,
                        width: challenge.isCompleted ? 50 : 40,
                        child: CircleAvatar(
                          backgroundColor: challenge.isCompleted ? Colors.green : Colors.orange,
                          child: Icon(
                            challenge.isCompleted ? Icons.check : Icons.star,
                            color: Colors.white,
                            size: challenge.isCompleted ? 30 : 25,
                          ),
                        ),
                      ).animate(target: challenge.isCompleted ? 1 : 0)
                       .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 400.ms, curve: Curves.elasticOut)
                       .then()
                       .scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 200.ms),
                       
                      title: Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: challenge.isCompleted ? TextDecoration.lineThrough : null,
                          color: challenge.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "Reward: ${challenge.reward.toInt()} coins",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: challenge.isCompleted
                          ? const Icon(Icons.emoji_events, color: Colors.amber, size: 32)
                              .animate()
                              .scale(duration: 600.ms, curve: Curves.elasticOut)
                              .fadeIn()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                challengeProvider.completeChallenge(challenge.id);
                                Provider.of<MoneyProvider>(context, listen: false)
                                    .addTransaction("Challenge Reward", challenge.reward, false);
                                
                                // Show animated snackbar or dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("🎉", style: TextStyle(fontSize: 60))
                                                  .animate()
                                                  .scale(duration: 600.ms, curve: Curves.elasticOut),
                                              const SizedBox(height: 16),
                                              const Text(
                                                "Challenge Complete!",
                                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "You earned +${challenge.reward.toInt()} coins!",
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                              ),
                                              const SizedBox(height: 24),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("Awesome!"),
                                              ),
                                            ],
                                          ),
                                        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Done!", style: TextStyle(color: Colors.white)),
                            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                             .shimmer(delay: 2.seconds, duration: 1.seconds),
                    ),
                  ).animate().slideX(delay: (100 * index).ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
