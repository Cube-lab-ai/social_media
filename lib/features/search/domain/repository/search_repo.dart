import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchProfileByUser(String query);
}
