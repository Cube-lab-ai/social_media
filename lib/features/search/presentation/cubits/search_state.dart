import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';

class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  List<ProfileUser?> user;
  SearchLoadedState({required this.user});
}

class SearchErrorState extends SearchState {
  String message;
  SearchErrorState({required this.message});
}
