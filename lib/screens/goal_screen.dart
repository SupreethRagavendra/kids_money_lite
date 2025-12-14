import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/goal_provider.dart';
import '../providers/money_provider.dart';
import '../models/goal_model.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Goal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "What do you want to buy?"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "How much does it cost?"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                Provider.of<GoalProvider>(context, listen: false).addGoal(
                  titleController.text,
                  double.tryParse(amountController.text) ?? 0.0,
                  "assets/images/piggy_bank_icon.png", // Placeholder
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _addToGoal(BuildContext context, Goal goal) {
    final moneyProvider = Provider.of<MoneyProvider>(context, listen: false);
    if (moneyProvider.balance < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You need more coins first!")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add to ${goal.title}"),
        content: const Text("Add 1 coin to this goal?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No")),
          ElevatedButton(
            onPressed: () {
              moneyProvider.addTransaction("Saved for ${goal.title}", 1.0, true);
              Provider.of<GoalProvider>(context, listen: false).addMoneyToGoal(goal.id, 1.0);
              
              // Check completion after update
              final updatedGoal = Provider.of<GoalProvider>(context, listen: false)
                  .goals
                  .firstWhere((g) => g.id == goal.id);
                  
              if (updatedGoal.isCompleted) {
                _confettiController.play();
                setState(() {}); // Trigger rebuild to show Lottie
              }
              
              Navigator.pop(ctx);
            },
            child: const Text("Yes, Add 1 Coin"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green
      appBar: AppBar(
        title: const Text("My Goals"),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: goalProvider.goals.isEmpty
                ? const Center(
                    child: Text(
                      "No goals yet. Add one!",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: goalProvider.goals.length,
                    itemBuilder: (context, index) {
                      final goal = goalProvider.goals[index];
                      final progress = goal.currentAmount / goal.targetAmount;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.flag, size: 40, color: Colors.orange),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.title,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${goal.currentAmount.toInt()} / ${goal.targetAmount.toInt()} coins",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!goal.isCompleted)
                                    IconButton(
                                      icon: const Icon(Icons.add_circle, color: Colors.green, size: 40),
                                      onPressed: () => _addToGoal(context, goal),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Smooth Progress Bar
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: progress),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) => ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    minHeight: 20,
                                    backgroundColor: Colors.grey[200],
                                    color: goal.isCompleted ? Colors.amber : Colors.green,
                                  ),
                                ),
                              ),

                              if (goal.isCompleted)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "GOAL REACHED! 🎉",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Existing Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
          // Lottie Celebration Overlay
          if (_confettiController.state == ConfettiControllerState.playing)
            Positioned.fill(
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/animations/confetti.json',
                  repeat: false,
                  onLoaded: (composition) {
                     // Optional: play sound
                  },
                ),
              ),
            ),


        ],
      ),
    );
  }
}
