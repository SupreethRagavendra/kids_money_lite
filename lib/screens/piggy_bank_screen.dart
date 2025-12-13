import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/money_provider.dart';

class PiggyBankScreen extends StatefulWidget {
  const PiggyBankScreen({super.key});

  @override
  State<PiggyBankScreen> createState() => _PiggyBankScreenState();
}

class _PiggyBankScreenState extends State<PiggyBankScreen> {
  bool _isDroppingCoin = false;

  void _addCoin(BuildContext context, double amount) {
    setState(() {
      _isDroppingCoin = true;
    });
    
    // Simulate animation delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isDroppingCoin = false;
        });
        Provider.of<MoneyProvider>(context, listen: false).addTransaction("Added Coin", amount, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFE5E5), // Light pink
      appBar: AppBar(
        title: const Text("My Piggy Bank"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Piggy Bank Visual
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.savings_rounded,
                size: 200,
                color: Color(0xFFFF6B6B),
              ),
              if (_isDroppingCoin)
                Positioned(
                  top: 0,
                  child: const Icon(Icons.monetization_on, size: 40, color: Colors.amber)
                      .animate()
                      .slideY(begin: -2, end: 2, duration: 600.ms, curve: Curves.bounceOut)
                      .fadeOut(delay: 500.ms),
                ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Balance Display
          Text(
            "${moneyProvider.balance.toStringAsFixed(0)} Coins",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D4D4D),
            ),
          ).animate().scale(duration: 400.ms),
          
          const SizedBox(height: 40),
          
          // Add Coin Buttons
          const Text(
            "Add Coins",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CoinButton(amount: 1, onTap: () => _addCoin(context, 1)),
              const SizedBox(width: 20),
              _CoinButton(amount: 5, onTap: () => _addCoin(context, 5)),
              const SizedBox(width: 20),
              _CoinButton(amount: 10, onTap: () => _addCoin(context, 10)),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Recent History
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: moneyProvider.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = moneyProvider.transactions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: tx.isExpense ? Colors.red[100] : Colors.green[100],
                            child: Icon(
                              tx.isExpense ? Icons.remove : Icons.add,
                              color: tx.isExpense ? Colors.red : Colors.green,
                            ),
                          ),
                          title: Text(tx.title),
                          trailing: Text(
                            "${tx.isExpense ? '-' : '+'}${tx.amount.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tx.isExpense ? Colors.red : Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
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

class _CoinButton extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const _CoinButton({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.amber[700]!, width: 2),
        ),
        child: Center(
          child: Text(
            "+${amount.toInt()}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
        ),
      ),
    );
  }
}
