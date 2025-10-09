import '../data/account_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for managing accounts via backend API.
class AccountService {
  Account? _currentUser;
  String? _token;

  /// Register a new user via backend API. Throws on error.
  Future<void> register(String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/accounts/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentUser = Account(
        email: data['email'] ?? '',
        username: data['username'] ?? '',
        password: '', // Do not store password
      );
    } else {
      final error = _parseError(response.body);
      throw Exception(error);
    }
  }

  /// Login with username and password via backend API. Throws on error.
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/accounts/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      final user = data['user'];
      _currentUser = Account(
        email: user['email'] ?? '',
        username: user['username'] ?? '',
        password: '',
      );
    } else {
      final error = _parseError(response.body);
      throw Exception(error);
    }
  }

  /// Logout current user (client-side only).
  void logout() {
    _currentUser = null;
    _token = null;
  }

  /// Returns the currently logged in user, or null.
  Account? get currentUser => _currentUser;

  /// Returns true if a user is logged in.
  bool get isLoggedIn => _currentUser != null;

  /// Returns the JWT token if logged in.
  String? get token => _token;

  String _parseError(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map && data.containsKey('error')) {
        return data['error'].toString();
      }
      return body;
    } catch (_) {
      return body;
    }
  }
}
