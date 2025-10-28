import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/components/my_text_field.dart';
import 'package:social_media_firebase/features/posts/domain/entities/post.dart';
import 'package:social_media_firebase/features/posts/presentation/components/shimmer.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_cubit.dart';
import 'package:social_media_firebase/features/posts/presentation/cubits/post_state.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  TextEditingController captionController = TextEditingController();
  late final AuthCubits authuser = context.read<AuthCubits>();
  late final AppUser? user;

  PlatformFile? pickedFile;
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  void getCurrentUser() {
    user = authuser.currentUser;
  }

  void uploadPost() {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get Current User')),
      );
      return;
    }

    String? caption =
        (captionController.text.isNotEmpty) ? captionController.text : null;
    Uint8List? webpickedFile = kIsWeb ? pickedFile?.bytes : null;
    String? mobilePickedFile = kIsWeb ? null : pickedFile?.path;
    final postCubit = context.read<PostCubit>();
    Post post = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: user!.uid,
      userName: user!.name,
      text: captionController.text,
      postImageUrl: '',
      timeStamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    if (caption != null && pickedFile != null) {
      postCubit.createPost(
        post,
        imageBytes: webpickedFile,
        imagePath: mobilePickedFile,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Required Both Caption & Image')));
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Post'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadPost, icon: Icon(Icons.upload_file)),
        ],
      ),

      body: BlocConsumer<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostUploadingState || state is PostLoadingState) {
            return PostSkeletonShimmer();
          }
          return buildUpload(context);
        },
        listener: (context, state) {
          if (state is PostLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post Uploaded SucessFully')),
            );
            Navigator.pop(context);
          } else if (state is PostErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }

  Widget buildUpload(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: 100,
            height: 100,
            child:
                (kIsWeb && pickedFile != null)
                    ? Image.memory(pickedFile!.bytes!, fit: BoxFit.cover)
                    : (!kIsWeb && pickedFile != null)
                    ? Image.file(File(pickedFile!.path!), fit: BoxFit.cover)
                    : Center(
                      child: Icon(
                        Icons.info,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Caption',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
          MyTextField(hintText: 'Enter Caption', controller: captionController),
          SizedBox(height: 20),
          MaterialButton(
            onPressed: pickFile,
            color: Colors.blue,
            child: Text('Pick Image'),
          ),
        ],
      ),
    );
  }
}
