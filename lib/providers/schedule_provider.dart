import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../services/gemini_service.dart';

class ScheduleProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<GenerationHistory> _history = [];
  ThemeMode _themeMode = ThemeMode.system;
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = false;
  String? _generatedContent;

  List<Task> get tasks => _tasks;
  List<GenerationHistory> get history => _history;
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  String? get generatedContent => _generatedContent;

  ScheduleProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Tasks
    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((t) => Task.fromJson(jsonDecode(t))).toList();
    
    // Load History
    final historyJson = prefs.getStringList('history') ?? [];
    _history = historyJson.map((h) => GenerationHistory.fromJson(jsonDecode(h))).toList();
    
    // Load Theme
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save Tasks
    final tasksJson = _tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
    
    // Save History
    final historyJson = _history.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('history', historyJson);
    
    // Save Theme
    await prefs.setInt('themeMode', _themeMode.index);
  }

  void addTask(String title, DateTime dateTime) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      dateTime: dateTime,
    );
    _tasks.add(newTask);
    _saveData();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveData();
    notifyListeners();
  }

  void deleteHistory(String id) {
    _history.removeWhere((item) => item.id == id);
    _saveData();
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveData();
    notifyListeners();
  }

  Future<void> generateScheduleInsights() async {
    if (_tasks.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _geminiService.generateInsights(_tasks);
      _generatedContent = result;
      
      final historyItem = GenerationHistory(
        id: DateTime.now().toString(),
        content: result,
        timestamp: DateTime.now(),
      );
      
      _history.insert(0, historyItem);
      _saveData();
    } catch (e) {
      _generatedContent = "Error generating insights: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearGeneratedContent() {
    _generatedContent = null;
    notifyListeners();
  }
}