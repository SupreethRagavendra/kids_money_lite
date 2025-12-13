import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

enum AiMood { happy, sad, neutral, giving }

class MoneyProvider with ChangeNotifier {
  double _balance = 0.0;
  List<TransactionModel> _transactions = [];
  AiMood _currentMood = AiMood.happy;
  String _aiMessage = "You are doing great!";

  double get balance => _balance;
  List<TransactionModel> get transactions => _transactions;
  AiMood get currentMood => _currentMood;
  String get aiMessage => _aiMessage;

  MoneyProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _balance = prefs.getDouble('balance') ?? 0.0;
    
    final String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      final List<dynamic> jsonList = json.decode(transactionsString);
      _transactions = jsonList.map((e) => TransactionModel.fromJson(e)).toList();
    }
    _updateAiMood();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('balance', _balance);
    prefs.setString('transactions', json.encode(_transactions.map((e) => e.toJson()).toList()));
  }

  void addTransaction(String title, double amount, bool isExpense) {
    if (isExpense && amount > _balance) {
      // Should be handled by UI, but safety check
      return;
    }

    final newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      isExpense: isExpense,
    );

    if (isExpense) {
      _balance -= amount;
    } else {
      _balance += amount;
    }

    _transactions.insert(0, newTransaction);
    _saveData();
    _updateAiMood();
    notifyListeners();
  }

  void _updateAiMood() {
    if (_transactions.isEmpty) {
      _currentMood = AiMood.happy;
      _aiMessage = "Start saving coins!";
      return;
    }

    // Simple Rule-Based AI
    int recentSpends = 0;
    int recentSaves = 0;
    
    // Check last 5 transactions
    int count = 0;
    for (var t in _transactions) {
      if (count >= 5) break;
      if (t.isExpense) recentSpends++;
      else recentSaves++;
      count++;
    }

    if (recentSpends > recentSaves) {
      _currentMood = AiMood.sad;
      _aiMessage = "You are spending too fast!";
    } else if (_balance > 50 && recentSaves > recentSpends) {
      _currentMood = AiMood.happy;
      _aiMessage = "Wow! You are a super saver!";
    } else {
      _currentMood = AiMood.happy;
      _aiMessage = "Keep saving!";
    }
    
    // Special case for low balance
    if (_balance < 5 && _transactions.isNotEmpty) {
      _currentMood = AiMood.sad;
      _aiMessage = "Oh no! Piggy is almost empty.";
    }
  }
  
  // For parent to reset
  void resetData() async {
    _balance = 0.0;
    _transactions = [];
    _currentMood = AiMood.happy;
    _aiMessage = "Start fresh!";
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
