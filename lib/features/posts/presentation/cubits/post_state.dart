import 'package:social_media_firebase/features/posts/domain/entities/post.dart';

abstract class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  List<Post> post;
  PostLoadedState({required this.post});
}

class PostUploadingState extends PostState {}

class PostErrorState extends PostState {
  String message;
  PostErrorState({required this.message});
}
