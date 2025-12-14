import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../providers/money_provider.dart';

class PiggyBankScreen extends StatefulWidget {
  const PiggyBankScreen({super.key});

  @override
  State<PiggyBankScreen> createState() => _PiggyBankScreenState();
}

class _PiggyBankScreenState extends State<PiggyBankScreen> {
  bool _isDroppingCoin = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _addCoin(BuildContext context, double amount) {
    setState(() => _isDroppingCoin = true);
    
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isDroppingCoin = false);
        Provider.of<MoneyProvider>(context, listen: false).addTransaction("Added Coin", amount, false);
        _confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFB6C1), Color(0xFFFFE4E8), Color(0xFFFFF5F6)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Custom App Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "🐷 My Piggy Bank",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 4)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Piggy Bank with coin animation
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Glow effect
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF69B4).withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Piggy image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/app-icon.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB6C1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.savings_rounded, size: 100, color: Colors.white),
                          ),
                        ),
                      ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                      
                      // Dropping coin
                      if (_isDroppingCoin)
                        Positioned(
                          top: -30,
                          child: const Text('🪙', style: TextStyle(fontSize: 40))
                              .animate()
                              .slideY(begin: -1, end: 3, duration: 500.ms, curve: Curves.bounceOut)
                              .fadeOut(delay: 400.ms),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Balance Display Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💰', style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 12),
                        Text(
                          "${moneyProvider.balance.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Coins',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  
                  const SizedBox(height: 32),
                  
                  // Add Coin Buttons
                  const Text(
                    "✨ Add Coins ✨",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CoinButton(amount: 1, onTap: () => _addCoin(context, 1)),
                      const SizedBox(width: 16),
                      _CoinButton(amount: 5, onTap: () => _addCoin(context, 5)),
                      const SizedBox(width: 16),
                      _CoinButton(amount: 10, onTap: () => _addCoin(context, 10)),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recent History
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('📋', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Text(
                                "Recent Activity",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: moneyProvider.transactions.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('📭', style: TextStyle(fontSize: 48)),
                                        const SizedBox(height: 8),
                                        Text(
                                          'No activity yet!',
                                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                                        ),
                                        Text(
                                          'Add some coins to start saving.',
                                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: moneyProvider.transactions.length,
                                    itemBuilder: (context, index) {
                                      final tx = moneyProvider.transactions[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: tx.isExpense ? Colors.red[50] : Colors.green[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: tx.isExpense ? Colors.red[100] : Colors.green[100],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                tx.isExpense ? '📤' : '📥',
                                                style: const TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(child: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w500))),
                                            Text(
                                              "${tx.isExpense ? '-' : '+'}${tx.amount.toStringAsFixed(0)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: tx.isExpense ? Colors.red : Colors.green,
                                              ),
                                            ),
                                          ],
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
              
              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.amber, Colors.orange, Colors.pink, Colors.yellow],
                  numberOfParticles: 15,
                ),
              ),
            ],
          ),
        ),
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
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: const Color(0xFFFFE4B5), width: 3),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "+${amount.toInt()}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2)],
                ),
              ),
              const Text('🪙', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
    );
  }
}
