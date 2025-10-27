import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/posts/domain/repository/post_repo.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_state.dart';
import 'package:social_media_firebase/features/storage/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  StorageRepo storageRepo;
  PostRepo postRepo;
  PostCubit({required this.storageRepo, required this.postRepo})
    : super(PostInitialState());

  // create post by each post id
  Future<void> createPost(
    Post post, {
    Uint8List? imageBytes,
    String? imagePath,
  }) async {
    String? imageUrl;
    try {
      emit(PostUploadingState());
      if (imageBytes != null) {
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      if (imagePath != null) {
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      if (imageUrl == null) {
        emit(PostErrorState(message: 'Failed To Update Post Image'));
        return;
      }

      final updatedPost = post.copyWith(newImageUrl: imageUrl);

      await postRepo.createPost(updatedPost);

      fetchAllPost();
    } catch (e) {
      emit(PostErrorState(message: e.toString()));
    }
  }

  // fetch all the post
  Future<void> fetchAllPost() async {
    try {
      emit(PostLoadingState());

      final result = await postRepo.fetchAllPost();

      emit(PostLoadedState(post: result));
    } catch (e) {
      emit(PostErrorState(message: "Failed To Fetch Post $e"));
    }
  }

  Future<void> deletePost(String postid) async {
    try {
      postRepo.deletePost(postid);
      fetchAllPost();
    } catch (e) {
      emit(PostErrorState(message: 'failed to delete post $e'));
    }
  }
}
