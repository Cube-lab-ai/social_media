import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/profile/domain/repository/profile_repository.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_firebase/features/storage/storage_repo.dart';

class ProfileCubits extends Cubit<ProfileState> {
  ProfileRepository profilerepo;
  StorageRepo storagerepo;
  ProfileCubits({required this.profilerepo, required this.storagerepo})
    : super(ProfileInitialState());

  Future<void> fetchProfileUser(String uid) async {
    try {
      emit(ProfileLoadingState());
      ProfileUser? user = await profilerepo.fetchProfileUser(uid);
      if (user != null) {
        emit(ProfileLoadedState(user: user));
      } else {
        emit(ProfileErrorState(message: 'User not found'));
      }
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<ProfileUser?> fetchProfileUserById(String uid) async {
    final user = await profilerepo.fetchProfileUser(uid);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<void> updateProfileUser(
    String uid, {
    String? bio,
    Uint8List? profileImageWeb,
    String? profileImageMobile,
  }) async {
    try {
      emit(ProfileLoadingState());
      final ProfileUser? user = await profilerepo.fetchProfileUser(uid);
      if (user != null) {
        // downloadimage url
        String? downloadImageUrl;

        if (profileImageWeb != null || profileImageMobile != null) {
          if (profileImageWeb != null) {
            downloadImageUrl = await storagerepo.uploadProfileImageWeb(
              profileImageWeb,
              uid,
            );
          } else if (profileImageMobile != null) {
            downloadImageUrl = await storagerepo.uploadProfileImageMobile(
              profileImageMobile,
              uid,
            );
          }

          if (downloadImageUrl == null) {
            emit(ProfileErrorState(message: 'Unable to upload Image'));
            return;
          }
        }

        // update profile
        final updatedProfile = user.copyWith(
          newBio: bio,
          newProfileImageUrl: downloadImageUrl,
        );
        await profilerepo.updateProfileUser(updatedProfile);
        await fetchProfileUser(uid);
      } else {
        emit(
          ProfileErrorState(
            message: 'Failed to fetch profile for update profile',
          ),
        );
        return;
      }
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
}
