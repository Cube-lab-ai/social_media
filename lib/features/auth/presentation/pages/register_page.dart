import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:social_media_firebase/features/components/my_elevated_button.dart';
import 'package:social_media_firebase/features/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? ontap;
  const RegisterPage({super.key, required this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passworeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void submit() {
    if (passworeController.text == confirmPasswordController.text) {
      context.read<AuthCubits>().registerWithEmailPassword(
        nameController.text,
        emailController.text,
        passworeController.text,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password Does not match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 90,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 40),
                Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(hintText: 'Name', controller: nameController),

                const SizedBox(height: 20),
                MyTextField(hintText: 'Email', controller: emailController),
                SizedBox(height: 20),
                MyTextField(
                  hintText: 'Password',
                  controller: passworeController,
                ),
                SizedBox(height: 20),
                MyTextField(
                  hintText: 'Conform Password',
                  controller: confirmPasswordController,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: MyElevatedButton(
                    text: 'Register Now',
                    onPressed: submit,
                  ),
                ),
                SizedBox(height: 50),
                // Text(
                //   'Already Have an Account? Login Now',
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an Account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.ontap,
                      child: Text(
                        " LogIn Now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
