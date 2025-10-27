

import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.email,
    required this.bio,
    required this.profileImageUrl,
  });

  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
      uid: uid,
      name: name,
      email: email,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
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
    };
  }

  factory ProfileUser.fromMap(Map<String, dynamic> user) {
    return ProfileUser(
      uid: user['uid'],
      name: user['name'],
      email: user['email'],
      bio: user['bio'] ?? "",
      profileImageUrl: user['profileImageUrl'] ?? "",
    );
  }
}
