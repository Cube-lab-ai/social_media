// here taking the profile user object from the profile screen
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/components/my_text_field.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_states.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileUser user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController bioController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  PlatformFile? pickedFile;
  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: kIsWeb);
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  void updateProfile() async {
    // reading profile cubits
    final profileCubit = context.read<ProfileCubits>();

    // checking if bio is empty or not
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;

    // If file is picked on web then imageMobilePath null or else imageWebBytes is null
    final imageWebBytes = kIsWeb ? pickedFile?.bytes : null;
    final imageMobilePath = kIsWeb ? null : pickedFile?.path;

    // make sure weather user is selectd either bio or image and updating to the firestore
    if (newBio != null || pickedFile != null) {
      await profileCubit.updateProfileUser(
        widget.user.uid,
        bio: newBio,
        profileImageWeb: imageWebBytes,
        profileImageMobile: imageMobilePath,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please Enter bio or pick File')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: Icon(Icons.upload)),
        ],
      ),

      body: BlocConsumer<ProfileCubits, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), Text('Loading...')],
              ),
            );
          }
          return buildEditPage();
        },
        listener: (context, state) {
          if (state is ProfileLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile Updated SuccessFully')),
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget buildEditPage() {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          height: 200,
          width: 200,
          child:
              (kIsWeb && pickedFile != null)
                  ? Image.memory(pickedFile!.bytes!, fit: BoxFit.cover)
                  : (!kIsWeb && pickedFile != null)
                  ? Image.file(File(pickedFile!.path!), fit: BoxFit.cover)
                  : CachedNetworkImage(
                    imageUrl: widget.user.profileImageUrl,
                    imageBuilder: (context, imageProvider) {
                      return Image(image: imageProvider, fit: BoxFit.cover);
                    },
                    placeholder: (context, url) {
                      return CircularProgressIndicator();
                    },
                    errorWidget: (context, url, error) {
                      return Icon(
                        Icons.error,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
        ),
        SizedBox(height: 20),
        MaterialButton(
          onPressed: pickFile,
          color: Colors.blue,
          child: Text('Pick A File'),
        ),
        SizedBox(height: 20),
        Text(
          'Bio',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: MyTextField(
            hintText: widget.user.bio,
            controller: bioController,
          ),
        ),
      ],
    );
  }
}
