
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthEnticatedState extends AuthStates {
  final AppUser user;
  AuthEnticatedState({required this.user});
}

class UnAuthenticatedState extends AuthStates {
  String? message;
  UnAuthenticatedState({this.message});
}

class AuthLoadingState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String errorMessage;
  AuthErrorState({required this.errorMessage});
}
