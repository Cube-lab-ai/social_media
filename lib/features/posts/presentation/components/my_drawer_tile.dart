import 'package:flutter/material.dart';

class MyDrawerTile extends StatefulWidget {
  final void Function()? ontap;
  final IconData icon;
  final String text;
  const MyDrawerTile({
    super.key,
    required this.icon,
    required this.text,
    required this.ontap,
  });

  @override
  State<MyDrawerTile> createState() => _MyDrawerTileState();
}

class _MyDrawerTileState extends State<MyDrawerTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: ListTile(
        leading: Icon(
          widget.icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          widget.text,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
    );
  }
}
