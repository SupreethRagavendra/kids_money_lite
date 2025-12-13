class Goal {
  final String id;
  final String title;
  final double targetAmount;
  double currentAmount;
  final String iconPath;
  bool isCompleted;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.iconPath,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'iconPath': iconPath,
      'isCompleted': isCompleted,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      iconPath: json['iconPath'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
