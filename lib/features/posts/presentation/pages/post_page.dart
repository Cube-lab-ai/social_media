import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/posts/presentation/components/my_darawer.dart';
import 'package:social_media_firebase/features/posts/presentation/components/post_card.dart';
import 'package:social_media_firebase/features/posts/presentation/components/shimmer.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_cubit.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_state.dart';
import 'package:social_media_firebase/features/posts/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostCubit postCubit = context.read<PostCubit>();
  // late final ProfileCubits _profileCubits = context.read<ProfileCubits>();
  @override
  void initState() {
    super.initState();
    postCubit.fetchAllPost();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDarawer(),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadPostPage()),
              );
            },
            icon: Icon(Icons.add_circle_sharp),
          ),
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState || state is PostUploadingState) {
            return PostSkeletonShimmer();
          } else if (state is PostLoadedState) {
            List<Post> listPost = state.post;
            if (listPost.isEmpty) {
              return Center(
                child: Text(
                  'No Post Found',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: listPost.length,
                itemBuilder: (context, index) {
                  final post = listPost[index];
                  return PostCard(
                    post: post,
                    deletePost: () {
                      deletePost(post.id);
                    },
                  );
                },
              );
            }
          } else if (state is PostErrorState) {
            return Center(child: Text(state.message.toString()));
          } else {
            return Center(child: Text('Some thing went wrong'));
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
