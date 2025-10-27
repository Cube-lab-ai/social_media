import 'package:social_media_firebase/features/posts/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPost();
  Future<void> deletePost(String postId);
  Future<void> createPost(Post post);
  Future<Post?> fetchPostById(String postId);
  Future<void> togglePostLike(Post post);
}
