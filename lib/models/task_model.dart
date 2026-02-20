class Task {
  final String id;
  final String title;
  final DateTime dateTime;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}

class GenerationHistory {
  final String id;
  final String content;
  final DateTime timestamp;

  GenerationHistory({
    required this.id,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

 factory GenerationHistory.fromJson(Map<String, dynamic> json) {
    return GenerationHistory(
      id: json['id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}