import 'package:e_bon/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser? _createUserFromFirebase(User? user){
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future signUp({required String email, required String password}) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signIn({required String email, required String password}) async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}