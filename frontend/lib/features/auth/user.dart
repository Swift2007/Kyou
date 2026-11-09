// Responsibility: Plain Dart model for the authenticated user profile from the backend.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.isNewUser,
  });

  final String id;
  final String email;
  final bool isNewUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    email: json['email'] as String? ?? '',
    isNewUser: json['is_new_user'] as bool? ?? false,
  );
}
