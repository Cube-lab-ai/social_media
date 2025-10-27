import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/posts/presentation/components/my_drawer_tile.dart';
import 'package:social_media_firebase/features/profile/presentation/screens/profile_screen.dart';

class MyDarawer extends StatefulWidget {
  const MyDarawer({super.key});

  @override
  State<MyDarawer> createState() => _MyDarawerState();
}

class _MyDarawerState extends State<MyDarawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
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
                  final result = context.read<AuthCubits>().currentUser;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(uid: result!.uid),
                    ),
                  );
                },
                icon: Icons.person,
                text: 'P R O F I L E',
              ),
              MyDrawerTile(
                ontap: () {},
                icon: Icons.search,
                text: 'S E A R C H',
              ),
              MyDrawerTile(
                ontap: () {},
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
