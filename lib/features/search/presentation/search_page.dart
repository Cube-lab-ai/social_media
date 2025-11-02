import 'package:flutter/material.dart';

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
    print('Searching: ${_searchController.text}');
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
      body: Center(child: Text('Type in the search bar')),
    );
  }
}
