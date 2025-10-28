import 'package:social_media_firebase/features/posts/domain/entities/comments.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPost();
  Future<void> deletePost(String postId);
  Future<void> createPost(Post post);
  Future<Post?> fetchPostById(String postId);
  Future<void> togglePostLike(Post post);
  Future<void> addComment(String postId, List<Map<String, dynamic>> comment);
  Future<void> deleteComment(String postId, String commentId);
}
