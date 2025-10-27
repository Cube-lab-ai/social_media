import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_firebase/features/auth/domain/repositories/auth_repo.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_states.dart';

class AuthCubits extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  AuthCubits({required this.authRepo}) : super(AuthInitialState());

  // check user is already authenticated
  void checkAuth() async {
    final result = await authRepo.getCurrentUser();
    if (result != null) {
      _currentUser = result;
      emit(AuthEnticatedState(user: result));
      return;
    }
    emit(UnAuthenticatedState());
  }

  AppUser? get currentUser => _currentUser;

  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      emit(AuthLoadingState());
      final AppUser? user = await authRepo.loginWithEmailPassword(
        email,
        password,
      );
      if (user != null) {
        _currentUser = user;
        emit(AuthEnticatedState(user: user));
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
      emit(UnAuthenticatedState());
    }
  }

  Future<void> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      emit(AuthLoadingState());
      final AppUser? user = await authRepo.registerWithEmailPassword(
        name,
        email,
        password,
      );
      if (user != null) {
        _currentUser = user;
        emit(AuthEnticatedState(user: user));
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
      emit(UnAuthenticatedState());
    }
  }

  Future<void> logOut() async {
    authRepo.logout();
    emit(UnAuthenticatedState(message: 'Log Out Success'));
  }
}
