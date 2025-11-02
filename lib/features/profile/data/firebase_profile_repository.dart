import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/profile/domain/repository/profile_repository.dart';

class FirebaseProfileRepository extends ProfileRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchProfileUser(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userdocument =
          await _firebaseFirestore.collection('users').doc(uid).get();
      if (userdocument.exists) {
        Map<String, dynamic>? userdata = userdocument.data();
        if (userdata != null) {
          return ProfileUser(
            uid: uid,
            name: userdata['name'],
            email: userdata['email'],
            bio: userdata['bio'] ?? "",
            profileImageUrl: userdata['profileImageUrl'] ?? "",
            followers: List<String>.from(userdata['followers'] ?? []),
            following: List<String>.from(userdata['following'] ?? []),
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateProfileUser(ProfileUser user) async {
    try {
      await _firebaseFirestore.collection('users').doc(user.uid).update({
        "bio": user.bio,
        'profileImageUrl': user.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(
    ProfileUser currentUser,
    ProfileUser targetUser,
  ) async {
    if (currentUser.following.contains(targetUser.uid)) {
      await _firebaseFirestore.collection('users').doc(currentUser.uid).update({
        "following": FieldValue.arrayRemove([targetUser.uid]),
      });

      await _firebaseFirestore.collection('users').doc(targetUser.uid).update({
        "followers": FieldValue.arrayRemove([currentUser.uid]),
      });
    } else {
      await _firebaseFirestore.collection('users').doc(currentUser.uid).update({
        "following": FieldValue.arrayUnion([targetUser.uid]),
      });

      await _firebaseFirestore.collection('users').doc(targetUser.uid).update({
        "followers": FieldValue.arrayUnion([currentUser.uid]),
      });
    }
  }
}
