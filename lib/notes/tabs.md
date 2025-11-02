In Flutter, the bottom property of an AppBar is used to add a widget that appears below the main toolbar area

🔍 Explanation
The AppBar widget has a property:
    final PreferredSizeWidget? bottom;

That means the widget you assign to bottom must implement the PreferredSizeWidget interface — so Flutter knows how tall to make it.
The most common use is to place a TabBar there.

🧱 Example with TabBar

import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AppBar with Bottom TabBar'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.star), text: 'Favorites'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home Tab')),
            Center(child: Text('Favorites Tab')),
            Center(child: Text('Profile Tab')),
          ],
        ),
      ),
    );
  }
}



🧩 Example with a Custom Widget in Bottom
You can also add any custom widget (as long as it’s a PreferredSizeWidget):

appBar: AppBar(
  title: const Text('Custom Bottom Widget'),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: Container(
      color: Colors.blue[100],
      height: 40,
      alignment: Alignment.center,
      child: const Text('This is a custom bottom widget'),
    ),
  ),
),



✅ The Widget That Implements PreferredSizeWidget

TabBar (from material.dart) implements PreferredSizeWidget.
That’s why you can directly assign it to AppBar.bottom:

appBar: AppBar(
  title: const Text('Example'),
  bottom: const TabBar(   // <-- This works because TabBar implements PreferredSizeWidget
    tabs: [
      Tab(text: 'Home'),
      Tab(text: 'Profile'),
    ],
  ),
),
