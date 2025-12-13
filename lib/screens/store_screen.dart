import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/money_provider.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  final List<Map<String, dynamic>> _storeItems = const [
    {'name': 'Ice Cream', 'price': 5.0, 'icon': Icons.icecream},
    {'name': 'Toy Car', 'price': 15.0, 'icon': Icons.directions_car},
    {'name': 'Ball', 'price': 10.0, 'icon': Icons.sports_soccer},
    {'name': 'Robot', 'price': 25.0, 'icon': Icons.smart_toy},
    {'name': 'Bike', 'price': 50.0, 'icon': Icons.pedal_bike},
    {'name': 'Game', 'price': 30.0, 'icon': Icons.videogame_asset},
  ];

  void _buyItem(BuildContext context, String name, double price) {
    final moneyProvider = Provider.of<MoneyProvider>(context, listen: false);
    
    if (moneyProvider.balance >= price) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Buy Item?"),
          content: Text("Do you want to buy $name for $price coins?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                moneyProvider.addTransaction("Bought $name", price, true);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("You bought a $name!")),
                );
              },
              child: const Text("Yes!"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not enough coins! Save more!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue
      appBar: AppBar(
        title: const Text("Smart Store"),
        backgroundColor: Colors.transparent,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "${moneyProvider.balance.toInt()} 💰",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: _storeItems.length,
          itemBuilder: (context, index) {
            final item = _storeItems[index];
            final canAfford = moneyProvider.balance >= item['price'];
            
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: InkWell(
                onTap: () => _buyItem(context, item['name'], item['price']),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 60, color: Colors.blue),
                    const SizedBox(height: 12),
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: canAfford ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${item['price'].toInt()} Coins",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
