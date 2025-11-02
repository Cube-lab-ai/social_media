import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final String postCount;
  final String followersCount;
  final String followingCount;
  final void Function()? onTap;
  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleForCount = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );
    TextStyle textStyleForText = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Column(
              children: [
                Text('Posts', style: textStyleForText),
                Text(postCount, style: textStyleForCount),
              ],
            ),
          ),

          SizedBox(
            width: 80,
            child: Column(
              children: [
                Text('Followers', style: textStyleForText),
                Text(followersCount, style: textStyleForCount),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: Column(
              children: [
                Text('Following', style: textStyleForText),
                Text(followingCount, style: textStyleForCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
