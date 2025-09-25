import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> initialize() async {
    _token = await AuthService.getToken();
    _user = await AuthService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await AuthService.login(email, password);
    
    if (result != null) {
      _token = result['token'];
      _user = User.fromJson(result['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String email, String password, String name, String type) async {
    _isLoading = true;
    notifyListeners();

    final success = await AuthService.register(email, password, name, type);
    
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _token = null;
    notifyListeners();
  }
}