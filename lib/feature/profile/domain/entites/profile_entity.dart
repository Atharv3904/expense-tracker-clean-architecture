class ProfileEntity {
  final String id;
  final String? email;
  final String? name;
  final String? avatarPath;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarPath,
    this.avatarUrl,
  });
}
