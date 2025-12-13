import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal_model.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  GoalProvider() {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final String? goalsString = prefs.getString('goals');
    if (goalsString != null) {
      final List<dynamic> jsonList = json.decode(goalsString);
      _goals = jsonList.map((e) => Goal.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('goals', json.encode(_goals.map((e) => e.toJson()).toList()));
  }

  void addGoal(String title, double targetAmount, String iconPath) {
    final newGoal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      targetAmount: targetAmount,
      iconPath: iconPath,
    );
    _goals.add(newGoal);
    _saveGoals();
    notifyListeners();
  }

  void addMoneyToGoal(String goalId, double amount) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index].currentAmount += amount;
      if (_goals[index].currentAmount >= _goals[index].targetAmount) {
        _goals[index].currentAmount = _goals[index].targetAmount;
        _goals[index].isCompleted = true;
      }
      _saveGoals();
      notifyListeners();
    }
  }
  
  void deleteGoal(String goalId) {
    _goals.removeWhere((g) => g.id == goalId);
    _saveGoals();
    notifyListeners();
  }
}
