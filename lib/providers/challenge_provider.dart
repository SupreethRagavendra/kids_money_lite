import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge_model.dart';

class ChallengeProvider with ChangeNotifier {
  List<Challenge> _challenges = [];

  List<Challenge> get challenges => _challenges;

  ChallengeProvider() {
    _loadChallenges();
  }
  
  // Simple predefined challenges
  final List<Map<String, dynamic>> _dailyTemplates = [
    {'desc': 'Save 5 coins today', 'reward': 2.0},
    {'desc': 'Do not spend any money', 'reward': 5.0},
    {'desc': 'Clean your room', 'reward': 3.0},
    {'desc': 'Read a book', 'reward': 2.0},
    {'desc': 'Help parents', 'reward': 4.0},
  ];

  Future<void> _loadChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final String? challengesString = prefs.getString('challenges');
    final String? lastDate = prefs.getString('challenge_date');
    
    // Check if new day
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    
    if (lastDate != todayStr) {
      _generateDailyChallenges();
    } else {
      if (challengesString != null) {
        final List<dynamic> jsonList = json.decode(challengesString);
        _challenges = jsonList.map((e) => Challenge.fromJson(e)).toList();
      } else {
        _generateDailyChallenges();
      }
    }
    notifyListeners();
  }

  void _generateDailyChallenges() async {
    _challenges = [];
    final now = DateTime.now();
    // Pick 3 random challenges
    final shuffled = List.of(_dailyTemplates)..shuffle();
    for (int i = 0; i < 3; i++) {
      _challenges.add(Challenge(
        id: "${now.millisecondsSinceEpoch}_$i",
        description: shuffled[i]['desc'],
        reward: shuffled[i]['reward'],
        date: now,
      ));
    }
    
    final prefs = await SharedPreferences.getInstance();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    prefs.setString('challenge_date', todayStr);
    _saveChallenges();
    notifyListeners();
  }

  Future<void> _saveChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('challenges', json.encode(_challenges.map((e) => e.toJson()).toList()));
  }

  void completeChallenge(String id) {
    final index = _challenges.indexWhere((c) => c.id == id);
    if (index != -1 && !_challenges[index].isCompleted) {
      _challenges[index].isCompleted = true;
      _saveChallenges();
      notifyListeners();
    }
  }
}
