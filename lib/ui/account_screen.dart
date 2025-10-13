import 'package:flutter/material.dart';

import '../domain/account_service.dart';

class AccountScreen extends StatefulWidget {
  final Widget? child;
  const AccountScreen({super.key, required this.child});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountService _service = AccountService();
  final TextEditingController _regEmailCtrl = TextEditingController();
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _regUserCtrl = TextEditingController();
  final TextEditingController _regPassCtrl = TextEditingController();
  String? _error;
  bool _showRegister = false;

  void _login() async {
    setState(() {
      _error = null;
    });
    try {
      await _service.login(_userCtrl.text, _passCtrl.text);
      setState(() {});
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _logout() {
    _service.logout();
    setState(() {});
  }

  void _register() async {
    setState(() {
      _error = null;
    });
    try {
      print("registe beginss service");
      await _service.register(
        _regEmailCtrl.text,
        _regUserCtrl.text,
        _regPassCtrl.text,
      );
      _showRegister = false;
      _userCtrl.text = _regUserCtrl.text;
      _passCtrl.text = _regPassCtrl.text;
      _regUserCtrl.clear();
      _regPassCtrl.clear();
      setState(() {});
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_service.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Konto')),
        body: Center(child: _showRegister ? _buildRegister() : _buildLogin()),
      );
    }
    // If a child widget is provided, show it as the main app content after login
    return widget.child ?? _buildProfile();
  }

  Widget _buildLogin() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Anmelden',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _userCtrl,
            decoration: const InputDecoration(labelText: 'Benutzername'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(labelText: 'Passwort'),
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => _login(),
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => setState(() => _showRegister = true),
            child: const Text('Noch kein Konto? Jetzt registrieren'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegister() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Registrieren',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _regEmailCtrl,
            decoration: const InputDecoration(labelText: 'E-Mail'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _regUserCtrl,
            decoration: const InputDecoration(labelText: 'Benutzername'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _regPassCtrl,
            decoration: const InputDecoration(labelText: 'Passwort'),
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => _register(),
            child: const Text('Registrieren'),
          ),
          TextButton(
            onPressed: () => setState(() => _showRegister = false),
            child: const Text('Zurück zum Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final user = _service.currentUser;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_circle, size: 80),
          const SizedBox(height: 16),
          Text(
            'Willkommen, ${user?.username ?? ''}!',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _logout, child: const Text('Logout')),
        ],
      ),
    );
  }
}
