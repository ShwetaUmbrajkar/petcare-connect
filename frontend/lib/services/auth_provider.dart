import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  AppUser? _user;
  String? _token;
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isLoggedIn => _token != null;
  bool get isLoading => _isLoading;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.login(email, password);
      _token = data['token'];
      _user = AppUser.fromJson(data['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      _isLoading = false;
      notifyListeners();
      return null; // no error
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<String?> register(String name, String email, String password, String phone) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.register(name, email, password, phone);
      _token = data['token'];
      _user = AppUser.fromJson(data['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    _user = null;
    notifyListeners();
  }
}
