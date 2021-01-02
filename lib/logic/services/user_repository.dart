import 'package:firebase_auth/firebase_auth.dart';
import 'file:///C:/Users/yevhe/AndroidStudioProjects/form_it/lib/logic/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    var currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    return await _firebaseAuth.currentUser;
  }

  ///not in use

}

// Stream<User> get user {
//   return _firebaseAuth.authStateChanges().map(
//       _userFromFirebaseUser); // .map((FA.User user) => _userFromFirebaseUser(user));
// }
//
//
// Future signInAnon() async {
//   try {
//     // await Firebase.initializeApp();
//     UserCredential result = await _firebaseAuth.signInAnonymously();
//     User user = result.user;
//     return _userFromFirebaseUser(user);
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
//
// User _userFromFirebaseUser(FA.User user) {
//   return user != null ? User(uid: user.uid) : null;
// }
