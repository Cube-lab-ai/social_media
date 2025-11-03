import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/search/domain/repository/search_repo.dart';

class FirebaseSearchRepo extends SearchRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<List<ProfileUser?>> searchProfileByUser(String query) async {
    try {
      QuerySnapshot<Map<String, dynamic>> result =
          await _firebaseFirestore
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThanOrEqualTo: "$query\uf8ff")
              .get();

      return result.docs.map((doc) => ProfileUser.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
