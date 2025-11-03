import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/settings/theme_cubits.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubits>();
    bool isLightMode = themeCubit.isLightMode;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Theme', style: TextStyle(fontSize: 20)),
            CupertinoSwitch(
              value: isLightMode,
              onChanged: (value) {
                themeCubit.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
