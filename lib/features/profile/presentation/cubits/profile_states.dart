
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';

class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  ProfileUser user;
  ProfileLoadedState({required this.user});
}

class ProfileErrorState extends ProfileState {
  String message;
  ProfileErrorState({required this.message});
}
