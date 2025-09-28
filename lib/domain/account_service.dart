import '../data/account_model.dart';

/// Service for managing accounts. Forces registration before login.
class AccountService {
  final List<Account> _accounts = [];
  Account? _currentUser;

  /// Register a new user. Throws if username exists or invalid.
  void register(String email, String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Benutzername und Passwort dürfen nicht leer sein');
    }
    if (_accounts.any((a) => a.username == username)) {
      throw Exception('Benutzername existiert bereits');
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      throw Exception('Ungültige E-Mail-Adresse');
    }
    _accounts.add(
      Account(email: email, username: username, password: password),
    );
  }

  /// Login with username and password. Throws if not registered or wrong password.
  void login(String username, String password) {
    final user = _accounts.firstWhere(
      (a) => a.username == username && a.password == password,
      orElse: () => throw Exception('Falscher Benutzername oder Passwort'),
    );
    _currentUser = user;
  }

  /// Logout current user.
  void logout() {
    _currentUser = null;
  }

  /// Returns the currently logged in user, or null.
  Account? get currentUser => _currentUser;

  /// Returns true if a user is logged in.
  bool get isLoggedIn => _currentUser != null;
}
