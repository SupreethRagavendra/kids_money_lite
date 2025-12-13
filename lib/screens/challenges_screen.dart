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
                      leading: CircleAvatar(
                        backgroundColor: challenge.isCompleted ? Colors.green : Colors.orange,
                        radius: 30,
                        child: Icon(
                          challenge.isCompleted ? Icons.check : Icons.star,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
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
                          ? null
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Yay! You earned ${challenge.reward.toInt()} coins!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: const Text("Done!", style: TextStyle(color: Colors.white)),
                            ),
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
