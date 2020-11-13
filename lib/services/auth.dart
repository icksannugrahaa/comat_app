import 'package:comat_apps/helpers/my_helpers.dart';
import 'package:comat_apps/models/user.dart' as um;
import 'package:comat_apps/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final MyHelpers helpers = MyHelpers();

  um.User _userFromFirebase(User user) {
    return user != null ? um.User(uid: user.uid) : null; 
  }

  // Stream
  Stream <um.User> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Anonymous Sign in 
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {  
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Google Sign in
  Future signInWithGoogle() async {
    try {
      await Firebase.initializeApp();
      
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      User user = authResult.user;
      // print(user);
      await DatabaseService(uid: user.uid).updateUser(user.displayName, user.email, user.photoURL, user.phoneNumber);
      
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with Email and Password
  Future registerWithEmailAndPassword(String email, String password) async {  
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await DatabaseService(uid: user.uid).updateUser("New User"+helpers.getRandomString(5), email, "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png", "+62"+helpers.getNumberString(11));
  
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}