// here getting the appuser id from the drawer
// and the fetching the profile from the firestore using the uid
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_cubit.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_state.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/profile/presentation/components/bio_box.dart';
import 'package:social_media_firebase/features/profile/presentation/components/follower_page.dart';
import 'package:social_media_firebase/features/profile/presentation/components/profile_stats.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_firebase/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubits _profileCubits = context.read<ProfileCubits>();
  late final AuthCubits _authCubits = context.read<AuthCubits>();
  AppUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _profileCubits.fetchProfileUser(widget.uid);
    _currentUser = _authCubits.currentUser!;
    checkProfile();
  }

  void toggleFollow() {
    final currentState = _profileCubits.state;

    if (currentState is! ProfileLoadedState) {
      return;
    }

    final ProfileUser profileState = currentState.user;

    if (profileState.followers.contains(_currentUser!.uid)) {
      setState(() {
        profileState.followers.remove(_currentUser!.uid);
      });
    } else {
      setState(() {
        profileState.followers.add(_currentUser!.uid);
      });
    }

    _profileCubits.toggleFollow(_currentUser!.uid, widget.uid).catchError((e) {
      setState(() {
        setState(() {
          profileState.followers.add(_currentUser!.uid);
          profileState.followers.remove(_currentUser!.uid);
        });
      });
    });
  }

  // void toggleFollow() {
  //   final currentState = _profileCubits.state;

  //   if (currentState is! ProfileLoadedState) return;

  //   // Make a copy of the followers list to avoid mutating the Cubit's state
  //   final List<String> updatedFollowers = List.from(
  //     currentState.user.followers,
  //   );

  //   final isFollowing = updatedFollowers.contains(_currentUser!.uid);

  //   // Optimistically update the list
  //   setState(() {
  //     if (isFollowing) {
  //       updatedFollowers.remove(_currentUser!.uid);
  //     } else {
  //       updatedFollowers.add(_currentUser!.uid);
  //     }
  //   });

  //   // Call backend
  //   _profileCubits.toggleFollow(_currentUser!.uid, widget.uid).catchError((e) {
  //     // Revert changes on error
  //     setState(() {
  //       if (isFollowing) {
  //         updatedFollowers.add(_currentUser!.uid);
  //       } else {
  //         updatedFollowers.remove(_currentUser!.uid);
  //       }
  //     });
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Failed to update follow status')));
  //   });

  //   // Optional: store the updated list in a temp variable for UI
  //   // _tempFollowers = updatedFollowers;
  // }

  bool isOwnProfile = false;
  void checkProfile() {
    if (_currentUser!.uid == widget.uid) {
      isOwnProfile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubits, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(state.user.name),
                foregroundColor: Theme.of(context).colorScheme.primary,
                actions: [
                  if (isOwnProfile)
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EditProfileScreen(user: state.user),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings),
                    ),
                ],
              ),
              body: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    state.user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 175,
                    width: 175,
                    child: CachedNetworkImage(
                      imageUrl: state.user.profileImageUrl,
                      errorWidget: (context, url, error) {
                        return Icon(Icons.error, size: 50);
                      },
                      imageBuilder: (context, imageProvider) {
                        return Image(image: imageProvider, fit: BoxFit.cover);
                      },
                      placeholder:
                          (context, url) => CircularProgressIndicator(),
                    ),
                  ),

                  SizedBox(height: 20),

                  // displaying followers, following, total no of posts
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, poststate) {
                      int postCount = 0;
                      if (poststate is PostLoadedState) {
                        postCount =
                            poststate.post
                                .where((post) => post.userId == widget.uid)
                                .toList()
                                .length;
                      }

                      return ProfileStats(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => FollowerPage(
                                      followers: state.user.followers,
                                      following: state.user.following,
                                    ),
                              ),
                            ),
                        postCount: postCount.toString(),
                        followersCount: state.user.followers.length.toString(),
                        followingCount: state.user.following.length.toString(),
                      );
                    },
                  ),

                  // follow / unfollow button
                  SizedBox(height: 20),

                  if (!isOwnProfile)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: toggleFollow,
                        color:
                            state.user.followers.contains(_currentUser!.uid)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            state.user.followers.contains(_currentUser!.uid)
                                ? "Unfollow"
                                : "Follow",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),

                  // The Row itself will take all available horizontal space, because:

                  // It’s inside a Column, which gives its children unconstrained height but max width.

                  // A Row in such a context stretches to fill the horizontal space by default.

                  // However, the Row's children only take the space they need unless wrapped in widgets like Expanded or Spacer.

                  // So visually:

                  // The Row spans the full width of the screen, but the Container inside it only occupies the width of the text plus padding
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Bio',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  BioBox(text: state.user.bio),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 25.0, left: 25.0),
                        child: Text(
                          'Posts',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
                      if (state is PostLoadedState) {
                        final List<Post> postItem =
                            state.post
                                .where((post) => post.userId == widget.uid)
                                .toList();

                        if (postItem.isEmpty) {
                          return Text(
                            'No Post Found',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        } else {
                          return Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(25),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                        190, // Max width of each grid item
                                    crossAxisSpacing:
                                        10, // Space between columns
                                    mainAxisSpacing: 10, // Space between rows
                                    childAspectRatio:
                                        1, // Square cells (width:height = 1:1)
                                  ),
                              itemCount: postItem.length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ), // Rounded corners (optional)
                                  child: Image.network(
                                    postItem[index].postImageUrl,
                                    fit:
                                        BoxFit
                                            .cover, // Ensures the image fills the box
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error, size: 50),
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                      return Center(child: Text('data'));
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
          // return buildShimmerLoading();
        }
      },
      listener: (context, state) {
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }

  Widget buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Avatar
          Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 300),
            color: Colors.grey.shade400,
            colorOpacity: 0.3,
            enabled: true,
            direction: const ShimmerDirection.fromLTRB(),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Pick file button
          Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 300),
            color: Colors.grey.shade400,
            colorOpacity: 0.3,
            enabled: true,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Bio label
          Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 300),
            color: Colors.grey.shade400,
            colorOpacity: 0.3,
            enabled: true,
            child: Container(
              height: 20,
              width: 80,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 10),
          // Bio text field
          Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 300),
            color: Colors.grey.shade400,
            colorOpacity: 0.3,
            enabled: true,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Extra placeholder button
          Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 300),
            color: Colors.grey.shade400,
            colorOpacity: 0.3,
            enabled: true,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
