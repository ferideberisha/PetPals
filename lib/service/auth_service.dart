import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:petpals/controllers/user_controller.dart';
import 'package:petpals/models/userModel.dart';

class AuthService {
  final UserController _userController = UserController();

  // Google Sign In
Future<User?> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      UserModel? userModel = await _userController.getUser(user.uid);

      if (userModel == null) {
        userModel = UserModel(
          uid: user.uid,
          firstName: user.displayName ?? '',
          lastName: '',
          email: user.email ?? '',
          role: 'walker',
          profilePicture: user.photoURL ?? '',
          phoneNumber: '',
          address: ''
        );
        await _userController.addUser(userModel);
      }

      // Check if the context is mounted before showing the dialog
      if (context.mounted) {
        print('Context is mounted, showing dialog.');
        WidgetsBinding.instance.addPostFrameCallback((_) {
        });
      } else {
        print('Context is not mounted.');
      }
    }

    return user;
  } catch (e) {
    print('Error during Google Sign-In: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error during Google Sign-In: $e')),
    );
    return null;
  }
}


  // Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
