import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:social_media_firebase/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';

import 'mock_auth_repo.dart'; // your mock file

void main() {
  late MockAuthRepo mockAuthRepo;
  late AuthCubits authCubit;

  final testUser = AppUser(
    uid: "123",
    name: "John Doe",
    email: "john@example.com",
  );

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    authCubit = AuthCubits(authRepo: mockAuthRepo);
  });

  tearDown(() {
    authCubit.close();
  });

  // -------------------------------------------------------
  // CHECK AUTH
  // -------------------------------------------------------
  blocTest<AuthCubits, AuthStates>(
    'emits AuthEnticatedState when getCurrentUser returns user',
    build: () {
      when(
        () => mockAuthRepo.getCurrentUser(),
      ).thenAnswer((_) async => testUser);
      return authCubit;
    },
    act: (cubit) => cubit.checkAuth(),
    expect:
        () => [
          isA<AuthEnticatedState>().having(
            (state) => state.user,
            'user',
            testUser,
          ),
        ],
  );

  blocTest<AuthCubits, AuthStates>(
    'emits UnAuthenticatedState when getCurrentUser returns null',
    build: () {
      when(() => mockAuthRepo.getCurrentUser()).thenAnswer((_) async => null);
      return authCubit;
    },
    act: (cubit) => cubit.checkAuth(),
    expect: () => [UnAuthenticatedState()],
  );

  // -------------------------------------------------------
  // LOGIN
  // -------------------------------------------------------
  blocTest<AuthCubits, AuthStates>(
    'login success → emits [Loading, Authenticated]',
    build: () {
      when(
        () => mockAuthRepo.loginWithEmailPassword(any(), any()),
      ).thenAnswer((_) async => testUser);
      return authCubit;
    },
    act:
        (cubit) => cubit.loginWithEmailPassword("john@example.com", "password"),
    expect:
        () => [
          isA<AuthLoadingState>(),
          isA<AuthEnticatedState>().having((state) => state.user, '', testUser),
        ],
  );

  blocTest<AuthCubits, AuthStates>(
    'login fail → emits [Loading, UnAuthenticated]',
    build: () {
      when(
        () => mockAuthRepo.loginWithEmailPassword(any(), any()),
      ).thenAnswer((_) async => null);
      return authCubit;
    },
    act: (cubit) => cubit.loginWithEmailPassword("wrong@example.com", "wrong"),
    expect: () => [isA<AuthLoadingState>(), isA<UnAuthenticatedState>()],
  );

  blocTest<AuthCubits, AuthStates>(
    'login error → emits [Loading, Error, UnAuthenticated]',
    build: () {
      when(
        () => mockAuthRepo.loginWithEmailPassword(any(), any()),
      ).thenThrow(Exception("Login error"));
      return authCubit;
    },
    act: (cubit) => cubit.loginWithEmailPassword("err@example.com", "err"),
    expect:
        () => [
          isA<AuthLoadingState>(),
          isA<AuthErrorState>(),
          isA<UnAuthenticatedState>(),
        ],
  );

  // -------------------------------------------------------
  // REGISTER
  // -------------------------------------------------------
  blocTest<AuthCubits, AuthStates>(
    'register success → emits [Loading, Authenticated]',
    build: () {
      when(
        () => mockAuthRepo.registerWithEmailPassword(any(), any(), any()),
      ).thenAnswer((_) async => testUser);
      return authCubit;
    },
    act:
        (cubit) => cubit.registerWithEmailPassword(
          "John",
          "john@example.com",
          "123456",
        ),
    expect:
        () => [
          isA<AuthLoadingState>(),
          isA<AuthEnticatedState>().having((state) => state.user, '', testUser),
        ],
  );

  // -------------------------------------------------------
  // LOGOUT
  // -------------------------------------------------------
  blocTest<AuthCubits, AuthStates>(
    'logout → emits UnAuthenticatedState(message: "Log Out Success")',
    build: () {
      when(() => mockAuthRepo.logout()).thenAnswer((_) async => {});
      return authCubit;
    },
    act: (cubit) => cubit.logOut(),
    expect:
        () => [
          isA<UnAuthenticatedState>().having(
            (s) => s.message,
            'message',
            "Log Out Success",
          ),
        ],
  );
}
