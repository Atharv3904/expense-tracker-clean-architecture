class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.role,
  });

  final String id;
  final String email;
  final String role;
}
