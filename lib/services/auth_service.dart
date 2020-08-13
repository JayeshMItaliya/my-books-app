import 'dart:async';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meta/meta.dart';

class User {
User({
  this.uid,
  this.email,
  this.photoUrl,
  this.displayName,
});

String uid;
String email;
String photoUrl;
String displayName;
}

abstract class AuthService {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<User> signInWithEmailAndLink({String email, String link});
  Future<bool> isSignInWithEmailLink(String link);
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  });
  Future<User> signInWithGoogle();
//  Future<User> signInWithFacebook();
  Future<User> signInWithApple({List<Scope> scopes});
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  void dispose();
}
