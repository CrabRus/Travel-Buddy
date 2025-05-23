class User {
  String name;
  String email;
  int savedCount;
  int visitedCount;
  String language;
  bool notificationsEnabled;

  User({
    required this.name,
    required this.email,
    this.savedCount = 0,
    this.visitedCount = 0,
    this.language = 'Українська',
    this.notificationsEnabled = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      savedCount: json['savedCount'] ?? 0,
      visitedCount: json['visitedCount'] ?? 0,
      language: json['language'] ?? 'Українська',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'savedCount': savedCount,
      'visitedCount': visitedCount,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
    };
  }
}