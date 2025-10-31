// here getting the appuser id from the drawer
// and the fetching the profile from the firestore using the uid
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_cubit.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_state.dart';
import 'package:social_media_firebase/features/profile/presentation/components/bio_box.dart';
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
  @override
  void initState() {
    super.initState();
    _profileCubits.fetchProfileUser(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubits, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(state.user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditProfileScreen(user: state.user),
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
                    placeholder: (context, url) => CircularProgressIndicator(),
                  ),
                ),

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
                    print(state);
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
                                  crossAxisSpacing: 10, // Space between columns
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
