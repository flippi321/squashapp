import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squashmate/models/user_model.dart';
import 'package:squashmate/screens/homepage.dart';
import 'package:squashmate/screens/user_registration/loginpage.dart';
import 'package:squashmate/services/auth_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    // Get user information from AuthService
    UserModel? user = authService.currentUser; // Assuming you have a User model

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: user != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the user image (replace 'userImage' with your actual image)
                  const Image(
                    image: AssetImage('assets/images/default_image.jpg'),
                  ),
                  const SizedBox(height: 20),
                  Text(user.username),
                  const SizedBox(
                    height: 30,
                  ),
                  // Display the user's first name, last name, and username
                  Text('${user.firstName} ${user.lastName}'),
                  const SizedBox(
                    height: 100,
                  ),
                  TextButton(
                      onPressed: () {
                        final authService = context.read<AuthService>();
                        authService.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Log Out",
                      ))
                ],
              ),
            )
          : const SizedBox(
              height: 50,
            ),
    );
  }
}
