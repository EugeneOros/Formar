import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:firebase_core/firebase_core.dart';
import 'package:form_it/logic/models/user.dart';
import 'file:///C:/Users/yevhe/AndroidStudioProjects/form_it/lib/logic/services/database.dart';

class AuthService {
  final FA.FirebaseAuth _auth = FA.FirebaseAuth.instance;

  User _userFromFirebaseUser(FA.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.authStateChanges().map(
        _userFromFirebaseUser); // .map((FA.User user) => _userFromFirebaseUser(user));
  }

  Future signInAnon() async {
    try {
      // await Firebase.initializeApp();
      FA.UserCredential result = await _auth.signInAnonymously();
      FA.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      FA.UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FA.User user = credential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      FA.UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FA.User user = credential.user;

      await DatabaseService(uid:user.uid).createUserData("Eugene");

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
