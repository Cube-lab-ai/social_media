import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/posts/presentation/components/my_drawer_tile.dart';
import 'package:social_media_firebase/features/profile/domain/entites/profile_user.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_firebase/features/profile/presentation/screens/profile_screen.dart';
import 'package:social_media_firebase/features/search/presentation/screens/search_page.dart';
import 'package:social_media_firebase/features/settings/settings_page.dart';

class MyDarawer extends StatefulWidget {
  const MyDarawer({super.key});

  @override
  State<MyDarawer> createState() => _MyDarawerState();
}

class _MyDarawerState extends State<MyDarawer> {
  late final AuthCubits _authCubits = context.read<AuthCubits>();
  late final ProfileCubits _profileCubits = context.read<ProfileCubits>();
  AppUser? currentUser;
  ProfileUser? _profileUser;

  void getCurrentUser() {
    currentUser = _authCubits.currentUser;
  }

  void getProfleUser() async {
    final result = await _profileCubits.fetchProfileUserById(currentUser!.uid);
    if (result != null) {
      setState(() {
        _profileUser = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProfleUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Column(
                  children: [
                    if (_profileUser == null)
                      Icon(
                        Icons.person,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl: _profileUser!.profileImageUrl,
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.person,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                          imageBuilder: (context, imageProvider) {
                            return Image(
                              width: 70,
                              height: 70,
                              image: imageProvider,
                              fit: BoxFit.fill,
                            );
                          },
                          placeholder: (context, url) {
                            return CircularProgressIndicator();
                          },
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      currentUser!.email,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.tertiary),
              SizedBox(height: 10),
              MyDrawerTile(
                ontap: () {
                  Navigator.pop(context);
                },
                icon: Icons.home,
                text: 'H O M E',
              ),
              MyDrawerTile(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProfileScreen(uid: currentUser!.uid),
                    ),
                  );
                },
                icon: Icons.person,
                text: 'P R O F I L E',
              ),
              MyDrawerTile(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                icon: Icons.search,
                text: 'S E A R C H',
              ),
              MyDrawerTile(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                icon: Icons.settings,
                text: 'S E T T I N G S',
              ),
              const Spacer(),
              MyDrawerTile(
                ontap: () {
                  context.read<AuthCubits>().logOut();
                },
                icon: Icons.exit_to_app,
                text: 'L O G O U T',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
