import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_firebase/features/auth/presentation/pages/auth_pages.dart';
import 'package:social_media_firebase/features/posts/data/firebase_post_repo.dart';
import 'package:social_media_firebase/features/posts/presentation/components/shimmer.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_cubit.dart';
import 'package:social_media_firebase/features/posts/presentation/pages/post_page.dart';
import 'package:social_media_firebase/features/profile/data/firebase_profile_repository.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_firebase/features/storage/firebase_storage_repo.dart';
import 'package:social_media_firebase/themes/light_mode.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseProfileRepo = FirebaseProfileRepository();

  // storage repo
  final storageRepo = FirebaseStorageRepo();

  // post repo
  final postRepo = FirebasePostRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthCubits(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        BlocProvider(
          create:
              (context) => ProfileCubits(
                profilerepo: firebaseProfileRepo,
                storagerepo: storageRepo,
              ),
        ),

        BlocProvider(
          create:
              (context) =>
                  PostCubit(storageRepo: storageRepo, postRepo: postRepo),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.system,
        home: Scaffold(
          body: BlocConsumer<AuthCubits, AuthStates>(
            builder: (context, state) {
              if (state is AuthEnticatedState) {
                return HomePage();
              } else if (state is UnAuthenticatedState) {
                return AuthPages();
              } else {
                return PostSkeletonShimmer();
              }
            },
            listener: (context, state) {
              if (state is AuthEnticatedState) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Login Success')));
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login Failed ${state.errorMessage}')),
                );
              } else if (state is UnAuthenticatedState) {
                (state.message != null)
                    ? ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message.toString())),
                    )
                    : Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
