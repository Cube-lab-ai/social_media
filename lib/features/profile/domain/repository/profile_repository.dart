import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser?> fetchProfileUser(String uid);
  Future<void> updateProfileUser(ProfileUser user);
}
