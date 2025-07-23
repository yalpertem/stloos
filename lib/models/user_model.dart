class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });

  factory AppUser.fromSupabase(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['user_metadata']?['name'] as String?,
      avatarUrl: data['user_metadata']?['avatar_url'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}