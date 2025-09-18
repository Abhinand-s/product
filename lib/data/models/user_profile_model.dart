// A model class to represent user profile data
class UserProfile {
  final String name;
  final String phone;

  UserProfile({required this.name, required this.phone});

  // This factory constructor expects a Map (a single JSON object)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'N/A',
      phone: json['phone_number'] ?? 'N/A',
    );
  }
}