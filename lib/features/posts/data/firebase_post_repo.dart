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

  @override
  Future<Post?> fetchPostById(String postId) async {
    try {
      final DocumentSnapshot<Object?> doc =
          await _postCollection.doc(postId).get();
      if (doc.exists) {
        final docData = doc.data();
        return Post.fromMap(docData as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> togglePostLike(Post post) async {
    try {
      await _postCollection.doc(post.id).update({"likes": post.likes});
    } catch (e) {
      throw Exception('failed to toggle post likes');
    }
  }
}
