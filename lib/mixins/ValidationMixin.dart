mixin ValidationMixin {
  String? validateEmail(String? value) =>
      !value!.contains('@') ? 'Please enter a valid email' : null;

  String? validatePassword(String? value) =>
      (value!.length < 4) ? 'Password must be at least 4 characters' : null;

  String? validateSecondPassword(String? secondPassword, String firstPassword) {
    if (secondPassword != firstPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    // This regex allows letters, spaces, apostrophes, and hyphens
    // which can occur in names like O'Neill or Anne-Marie.
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      return 'Name must only contain letters';
    }

    List<String> nameParts = value.trim().split(RegExp(r'\s+'));
    if (nameParts.length < 2) {
      return 'Please enter your full name';
    }

    return null;
  }

}
