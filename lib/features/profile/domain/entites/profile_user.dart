import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.email,
    required this.bio,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
  });

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? follower,
    List<String>? following,
  }) {
    return ProfileUser(
      uid: uid,
      name: name,
      email: email,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: follower ?? followers,
      following: following ?? this.following,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "bio": bio,
      "profileImageUrl": profileImageUrl,
      "followers": followers,
      "following": following,
    };
  }

  factory ProfileUser.fromMap(Map<String, dynamic> user) {
    return ProfileUser(
      uid: user['uid'],
      name: user['name'],
      email: user['email'],
      bio: user['bio'] ?? "",
      profileImageUrl: user['profileImageUrl'] ?? "",
      followers: List<String>.from(user['followers'] ?? []),
      following: List<String>.from(user['following'] ?? []),
    );
  }
}
