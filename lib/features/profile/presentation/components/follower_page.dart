import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_firebase/features/profile/presentation/screens/profile_screen.dart';

// 🧠 Detailed Explanation

// DefaultTabController is just a controller widget — it provides a TabController to its descendants.

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;
  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            dividerColor: Colors.transparent,

            tabs: [Tab(child: Text('Followers')), Tab(text: 'Following')],
          ),
        ),
        body: TabBarView(
          children: [
            builList(followers, 'No Profile Found', context),
            builList(following, 'No Profile Found', context),
          ],
        ),
      ),
    );
  }

  Widget builList(List<String> uid, String emptyMessage, BuildContext context) {
    return uid.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
          itemCount: uid.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: context.read<ProfileCubits>().fetchProfileUserById(
                uid[index],
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final user = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        user!.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),

                      subtitle: Text(
                        user.email,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      leading: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        width: 40,
                        height: 40,
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl: user.profileImageUrl,
                          errorWidget: (context, url, error) {
                            return Icon(Icons.person);
                          },
                          placeholder:
                              (context, url) => CircularProgressIndicator(),

                          imageBuilder: (context, imageProvider) {
                            return Image.network(
                              user.profileImageUrl,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),

                      trailing: IconButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProfileScreen(uid: user.uid),
                              ),
                            ),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('User Not Found'));
                }
              },
            );
          },
        );
  }
}
