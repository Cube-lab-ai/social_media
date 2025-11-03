import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/profile/presentation/screens/profile_screen.dart';
import 'package:social_media_firebase/features/search/presentation/cubits/search_cubits.dart';
import 'package:social_media_firebase/features/search/presentation/cubits/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(searchUser);
  }

  @override
  void dispose() {
    _searchController.dispose(); // ✅ dispose before super
    super.dispose();
  }

  void searchUser() {
    context.read<SearchCubits>().searchProfileUser(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search User', // ✅ fixed
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      body: BlocConsumer<SearchCubits, SearchState>(
        builder: (context, state) {
          if (state is SearchLoadedState) {
            return ListView.builder(
              itemCount: state.user.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                      imageUrl: state.user[index]!.profileImageUrl,
                      imageBuilder: (context, imageProvider) {
                        return Image(image: imageProvider, fit: BoxFit.cover);
                      },
                      errorWidget: (context, url, error) {
                        return Icon(Icons.error, size: 40);
                      },
                      placeholder: (context, url) {
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  title: Text(state.user[index]!.name),
                  subtitle: Text(state.user[index]!.email),
                  trailing: GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ProfileScreen(uid: state.user[index]!.uid),
                          ),
                        ),
                    child: Icon(Icons.arrow_forward_ios, size: 34),
                  ),
                );
              },
            );
          } else if (state is SearchErrorState) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No Profile Users Found'));
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
