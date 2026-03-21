import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _onboardingComplete = false;
  bool _isLoading = false;
  String _generatedContent = '';
  List<Map<String, String>> _savedDocuments = [];
  String _userName = '';
  String _companyName = '';

  bool get onboardingComplete => _onboardingComplete;
  bool get isLoading => _isLoading;
  String get generatedContent => _generatedContent;
  List<Map<String, String>> get savedDocuments => _savedDocuments;
  String get userName => _userName;
  String get companyName => _companyName;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _companyName = prefs.getString('company_name') ?? '';
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String company) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('company_name', company);
    _userName = name;
    _companyName = company;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setGeneratedContent(String content) {
    _generatedContent = content;
    notifyListeners();
  }

  void addDocument(String type, String title, String content) {
    _savedDocuments.insert(0, {
      'type': type,
      'title': title,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  void clearContent() {
    _generatedContent = '';
    notifyListeners();
  }
}
