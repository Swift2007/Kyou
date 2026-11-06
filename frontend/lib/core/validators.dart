// Responsibility: Validates user input for forms such as auth and profile fields.

/// Email validators assume a simple shape check; deliverability is the backend's job.
String? validateEmail(String? value) {
  final email = (value ?? '').trim();
  if (email.isEmpty) {
    return 'Enter your email.';
  }
  final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailPattern.hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

/// Minimum length mirrors Supabase's default password policy of 6 characters.
String? validatePassword(String? value) {
  final password = value ?? '';
  if (password.isEmpty) {
    return 'Enter your password.';
  }
  if (password.length < 6) {
    return 'Password needs at least 6 characters.';
  }
  return null;
}
