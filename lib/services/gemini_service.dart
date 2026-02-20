import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyBjCRYXDykbPLXZKiG4QXGPfliMKu5G3fU';

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
  }

  Future<String> generateInsights(List<Task> tasks) async {
    if (tasks.isEmpty) {
      return "No tasks to generate insights from.";
    }

    final taskListString = tasks
        .map((t) {
          return "- ${t.title} at ${DateFormat('yyyy-MM-dd HH:mm').format(t.dateTime)}";
        })
        .join('\n');

    final prompt =
        '''
    Analyze the following schedule tasks and provide:
    1. SUMMARY: A brief summary of the schedule.
    2. TIPS: Practical tips for productivity based on these tasks.
    3. PRIORITY: Identify the most critical tasks.

    Tasks:
    $taskListString
    ''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    return response.text ?? "Unable to generate insights.";
  }
}
