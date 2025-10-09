class AccountValidator {
  static String? validateEmail(String email) {
    if (email.isEmpty) return 'E-Mail darf nicht leer sein';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); 
    if (!regex.hasMatch(email)) return 'Ungültige E-Mail-Adresse';
    return null;
  }

  static String? validateUsername(String username) {
    if (username.isEmpty) return 'Benutzername darf nicht leer sein';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Passwort darf nicht leer sein';
    if (password.length < 6)
      return 'Passwort muss mindestens 6 Zeichen lang sein';
    return null;
  }
}
