import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/helpers/my_helpers.dart';
import 'package:comat_apps/models/user.dart' as um;
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
      
      if(user.emailVerified) {
        return _userFromFirebase(user);
      } else {
        await _auth.signOut();
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Google Sign in 
  Future signInWithGoogle() async {
    try {
      
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      User user = authResult.user;
  
      await DatabaseServiceUsers(uid: user.uid).updateUser(user.displayName, user.email, user.photoURL, user.phoneNumber, true);
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
      try {
        await user.sendEmailVerification();
        await DatabaseServiceUsers(uid: user.uid).updateUser("New User"+helpers.getRandomString(5), email, "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png", "+62"+helpers.getNumberString(11), false);
        
        if(user.emailVerified) {
          return _userFromFirebase(user);
        } else {
          await _auth.signOut();
          return "please verify your email";
        }
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Reset Password
  Future changePassword(String oldPassword, String newPassword) async {
    try {
      User user = _auth.currentUser;
      final result = await _auth.signInWithEmailAndPassword(email: user.email, password: oldPassword);
      if(result.user != null) {
        await result.user.updatePassword(newPassword).then((_){
          print("Password change successfully !");
          return true;
        }).catchError((error){
          print("Password can't be changed" + error.toString());
          return false;
        });
      } else {
        print("Password before doesn't match !");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
      await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign Out
  Future signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}