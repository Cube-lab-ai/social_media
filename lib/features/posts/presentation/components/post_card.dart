import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_cubits.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final void Function() deletePost;
  const PostCard({super.key, required this.post, required this.deletePost});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final AuthCubits authCubits = context.read<AuthCubits>();
  late final ProfileCubits profileCubits = context.read<ProfileCubits>();
  bool isOnwPost = false;
  AppUser? currentUser;
  ProfileUser? profileUser;
  String dateTimeConvert(DateTime datetime) {
    final now = DateTime.now();
    final difference = now.difference(datetime);
    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} second ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minute ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour ago";
    } else if (difference.inDays < 365) {
      return "${difference.inDays} day ago";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years year ago";
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchProfileUser();
  }

  void getCurrentUser() {
    isOnwPost = (widget.post.userId == authCubits.currentUser!.uid);
  }

  void fetchProfileUser() async {
    final fetchedUser = await profileCubits.fetchProfileUserById(
      widget.post.userId,
    );
    if (fetchedUser != null) {
      setState(() {
        profileUser = fetchedUser;
      });
    }
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure want to delete post'),
          actions: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                widget.deletePost();
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        children: [
          ListTile(
            leading:
                (profileUser != null)
                    ? Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: profileUser!.profileImageUrl,
                        width: 40,
                        height: 40,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        placeholder:
                            (context, url) => CircularProgressIndicator(),
                      ),
                    )
                    : CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              widget.post.userName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            subtitle: Text(
              dateTimeConvert(widget.post.timeStamp),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            trailing:
                isOnwPost
                    ? IconButton(
                      onPressed: deletePost,
                      icon: Icon(Icons.delete, color: Colors.red),
                    )
                    : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CachedNetworkImage(
              imageUrl: widget.post.postImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 350,
              placeholder:
                  (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) =>
                      CircleAvatar(child: Icon(Icons.error)),
            ),
          ),
        ],
      ),
    );
  }
}
