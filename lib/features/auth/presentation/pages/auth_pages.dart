import 'package:flutter/material.dart';
import 'package:social_media_firebase/features/auth/presentation/pages/login_page.dart';
import 'package:social_media_firebase/features/auth/presentation/pages/register_page.dart';

class AuthPages extends StatefulWidget {
  const AuthPages({super.key});

  @override
  State<AuthPages> createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> {
  bool showLoginPage = true;
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(onTap: togglePage)
        : RegisterPage(ontap: togglePage);
  }
}
