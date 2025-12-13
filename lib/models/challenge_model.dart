class Challenge {
  final String id;
  final String description;
  final double reward;
  bool isCompleted;
  final DateTime date;

  Challenge({
    required this.id,
    required this.description,
    required this.reward,
    this.isCompleted = false,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'reward': reward,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      description: json['description'],
      reward: json['reward'],
      isCompleted: json['isCompleted'],
      date: DateTime.parse(json['date']),
    );
  }
}
