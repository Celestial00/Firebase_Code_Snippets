// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';


class AuthServies {
  FirebaseAuth Firebase_Auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential USER = await Firebase_Auth.createUserWithEmailAndPassword(email: email, password: password);

      return USER.user;
    } catch (e) {
      print(e);
    }
  }

  Future<User?> SignIn(String email, String password) async {
    try {
      final UserCredential USER =
          await Firebase_Auth.signInWithEmailAndPassword(
              email: email, password: password);

      return USER.user;
    } catch (e) {
      print(e);
    }
  }

  SignOut() {
    Firebase_Auth.signOut();
  }
}
