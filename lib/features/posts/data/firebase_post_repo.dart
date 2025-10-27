import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/posts/domain/repository/post_repo.dart';

class FirebasePostRepo extends PostRepo {
  final CollectionReference _postCollection = FirebaseFirestore.instance
      .collection('post');

  @override
  Future<List<Post>> fetchAllPost() async {
    try {
      QuerySnapshot<Object?> query =
          await _postCollection.orderBy('timeStamp', descending: true).get();
      return query.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching post $e");
    }
  }

  @override
  Future<void> createPost(Post post) async {
    try {
      await _postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _postCollection.doc(postId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
