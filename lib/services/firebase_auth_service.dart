import 'dart:math';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:byebye_flutter_app/bloc/login_bloc.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/save_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  User _userFromFirebase(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    bool complete = false;
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    complete = await getUserProfile(authResult.user.uid);
    if (complete) {
      prefsObject.setString('loginUid', authResult.user.uid);
      loginBloc.loginValue.sink.add(authResult.user.uid);
    }
    return _userFromFirebase(authResult.user);
  }

  Future<bool> getUserProfile(String uid) async {
    bool result = false;
    final Query userInfo =
        _firestore.collection('users').where('uid', isEqualTo: uid);
    final QuerySnapshot querySnapshot = await userInfo.getDocuments();
    if (querySnapshot.documents.isNotEmpty) {
      prefsObject.setString(
          'emailId', querySnapshot.documents[0].data['emailId']);
      prefsObject.setString('name', querySnapshot.documents[0].data['name']);
      prefsObject.setString(
          'photoUrl', querySnapshot.documents[0].data['photoUrl']);
      prefsObject.setString('uid', querySnapshot.documents[0].data['uid']);
      prefsObject.setString(
          'userStory', querySnapshot.documents[0].data['userStory']);
      prefsObject.setString(
          'gender', querySnapshot.documents[0].data['gender']);
      prefsObject.setString('age', querySnapshot.documents[0].data['age']);
      prefsObject.setString(
          'location', querySnapshot.documents[0].data['location']);
      prefsObject.setString(
          'workingIn', querySnapshot.documents[0].data['workingIn']);
      prefsObject.setString('userSince',
          querySnapshot.documents[0].data['createdOn'].toDate().toString());
      result = true;
    }
    return result;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    bool complete = false;
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    complete = await createNewUserInFirebase(authResult.user);
    if (complete) {
      prefsObject.setString('loginUid', authResult.user.uid);
      loginBloc.loginValue.sink.add(authResult.user.uid);
    }
    do {
      return _userFromFirebase(authResult.user);
    } while (complete);
  }

  Future<bool> createNewUserInFirebase(FirebaseUser user) async {
    bool result = false;
    final randomNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final digit =
        randomNumber.substring(randomNumber.length - 4, randomNumber.length);
    await _firestore.collection('users').document(user.uid).setData({
      'emailId': user.email,
      'name': 'user$digit',
      'photoUrl': '',
      'uid': user.uid,
      'userStory': '',
      'gender': '',
      'age': '',
      'location': '',
      'workingIn': '',
      'createdOn': DateTime.now(),
      'fans': [],
      'blockedBy': [],
      'views': 0,
      'libraryStatus': false,
    }).catchError((e) {
      result = false;
    }).then((_) {
      prefsObject.setString('emailId', user.email);
      prefsObject.setString('name', 'user$digit');
      prefsObject.setString('photoUrl', '');
      prefsObject.setString('uid', user.uid);
      prefsObject.setString('userStory', '');
      prefsObject.setString('gender', '');
      prefsObject.setString('age', '');
      prefsObject.setString('location', '');
      prefsObject.setString('workingIn', '');
      prefsObject.setString('userSince', DateTime.now().toString());
      result = true;
    });
    return result;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithEmailAndLink({String email, String link}) async {
    final AuthResult authResult =
        await _firebaseAuth.signInWithEmailAndLink(email: email, link: link);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return await _firebaseAuth.isSignInWithEmailLink(link);
  }

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  }) async {
    return await _firebaseAuth.sendSignInWithEmailLink(
      email: email,
      url: url,
      handleCodeInApp: handleCodeInApp,
      iOSBundleID: iOSBundleID,
      androidPackageName: androidPackageName,
      androidInstallIfNotAvailable: androidInstallIfNotAvailable,
      androidMinimumVersion: androidMinimumVersion,
    );
  }

  // TODO(marius): Third Party Login Removed due to restriction from App Store.

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        final dynamic checkUser = await checkCurrentUser(authResult.user);
        if (checkUser) {
          prefsObject.setString('loginUid', authResult.user.uid);
          loginBloc.loginValue.sink.add(authResult.user.uid);
          return _userFromFirebase(authResult.user);
        } else {
          throw PlatformException(
              code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
              message: 'Missing Google Auth Token');
        }
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

//  @override
//  Future<User> signInWithFacebook() async {
//    final FacebookLogin facebookLogin = FacebookLogin();
//    // https://github.com/roughike/flutter_facebook_login/issues/210
//    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//    final FacebookLoginResult result =
//        await facebookLogin.logIn(<String>['email', 'public_profile']);
//    if (result.accessToken != null) {
//      final AuthResult authResult = await _firebaseAuth.signInWithCredential(
//        FacebookAuthProvider.getCredential(
//            accessToken: result.accessToken.token),
//      );
//      final dynamic checkUser = await checkCurrentUser(authResult.user);
//      if (checkUser) {
//        prefsObject.setString('loginUid', authResult.user.uid);
//        loginBloc.loginValue.sink.add(authResult.user.uid);
//        return _userFromFirebase(authResult.user);
//      } else {
//        throw PlatformException(
//            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
//      }
//    } else {
//      throw PlatformException(
//          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
//    }
//  }

  @override
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final AuthorizationResult result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        final dynamic firebaseResponse =
            await checkAndCreateAppleUser(authResult.user);

        if (firebaseResponse[0]) {
          prefsObject.setString('loginUid', authResult.user.uid);
          loginBloc.loginValue.sink.add(authResult.user.uid);
          return _userFromFirebase(authResult.user);
        }

        if (scopes.contains(Scope.fullName)) {
          final updateUser = UserUpdateInfo();
          updateUser.displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(updateUser);
        }
        return _userFromFirebase(firebaseUser);
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sing in aborted by user',
        );
    }
    return null;
  }

  Future<dynamic> checkAndCreateAppleUser(FirebaseUser user) async {
    bool result = false;
    dynamic response;
    dynamic error;
    final Query userQuery =
        _firestore.collection('users').where('uid', isEqualTo: user.uid);
    final QuerySnapshot userQuerySnapshot = await userQuery.getDocuments();
    response = userQuerySnapshot.documents;
    if (response.isEmpty) {
      final randomNumber = DateTime.now().millisecondsSinceEpoch.toString();
      final digit =
          randomNumber.substring(randomNumber.length - 4, randomNumber.length);

      await _firestore.collection('users').document(user.uid).setData({
        'emailId': user.email == null ? '' : user.email,
        'name': 'user$digit',
        'photoUrl': '',
        'uid': user.uid,
        'userStory': '',
        'gender': '',
        'age': '',
        'location': '',
        'workingIn': '',
        'createdOn': DateTime.now(),
        'fans': [],
        'blockedBy': [],
        'views': 0,
        'libraryStatus': false,
      }).catchError((e) {
        error = e.toString();
      }).then((_) {
        prefsObject.setString('emailId', user.email == null ? '' : user.email);
        prefsObject.setString('name', 'user$digit');
        prefsObject.setString('photoUrl', '');
        prefsObject.setString('uid', user.uid);
        prefsObject.setString('userStory', '');
        prefsObject.setString('gender', '');
        prefsObject.setString('age', '');
        prefsObject.setString('location', '');
        prefsObject.setString('workingIn', '');
        prefsObject.setString('userSince', DateTime.now().toString());
        result = true;
      });
      return [result, error];
    }
  }

  Future<dynamic> checkCurrentUser(FirebaseUser user) async {
    final _saveFile = SaveFile();
    bool result = false;
    dynamic response;
    final Query userQuery =
        _firestore.collection('users').where('uid', isEqualTo: user.uid);
    final QuerySnapshot userQuerySnapshot = await userQuery.getDocuments();
    response = userQuerySnapshot.documents;
    if (response.isEmpty) {
      //upload user profile pic if he/she have.
      if (user.photoUrl.isNotEmpty) {
        final dynamic filePath = await _saveFile.localPath(user.photoUrl);
        final dynamic uploadResult = await uploadUserPhoto(filePath);
        if (uploadResult[1].error == null) {
          final dynamic firebaseResponse =
              await createNewFacebookOrGoogleUserInFirebase(
                  user, uploadResult[0]);
          if (firebaseResponse[0]) {
            result = true;
            return result;
          }
        }
      } else {
        final dynamic firebaseResponse =
            await createNewFacebookOrGoogleUserInFirebase(user, '');
        if (firebaseResponse[0]) {
          result = true;
          return result;
        }
      }
    } else {
      prefsObject.setString('emailId', response[0].data['emailId']);
      prefsObject.setString('name', response[0].data['name']);
      prefsObject.setString('photoUrl', response[0].data['photoUrl']);
      prefsObject.setString('uid', response[0].data['uid']);
      prefsObject.setString('userStory', response[0].data['userStory']);
      prefsObject.setString('gender', response[0].data['gender']);
      prefsObject.setString('age', response[0].data['age']);
      prefsObject.setString('location', response[0].data['location']);
      prefsObject.setString('workingIn', response[0].data['workingIn']);
      prefsObject.setString(
          'userSince', response[0].data['createdOn'].toDate().toString());
      result = true;
      return result;
    }
  }

  Future<dynamic> uploadUserPhoto(dynamic image) async {
    final random = Random();
    final int randomNo = random.nextInt(1000);
    final String imageName = 'ProfileImage' + randomNo.toString();
    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('userDetails')
        .child('profileImages')
        .child(imageName);
    final StorageUploadTask storageUploadTask = storageReference.putFile(image);
    final downloadUrl =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    final StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    return [downloadUrl, storageTaskSnapshot];
  }

  Future<dynamic> createNewFacebookOrGoogleUserInFirebase(
      FirebaseUser user, String photoUrl) async {
    bool result = false;
    dynamic error;
    final randomNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final digit =
        randomNumber.substring(randomNumber.length - 4, randomNumber.length);

    await _firestore.collection('users').document(user.uid).setData({
      'emailId': user.email == null ? '' : user.email,
      'name': 'user$digit',
      'photoUrl': photoUrl,
      'uid': user.uid,
      'userStory': '',
      'gender': '',
      'age': '',
      'location': '',
      'workingIn': '',
      'createdOn': DateTime.now(),
      'fans': [],
      'blockedBy': [],
      'views': 0,
      'libraryStatus': false,
    }).catchError((e) {
      error = e.toString();
    }).then((_) {
      prefsObject.setString('emailId', user.email == null ? '' : user.email);
      prefsObject.setString('name', 'user$digit');
      prefsObject.setString('photoUrl', photoUrl);
      prefsObject.setString('uid', user.uid);
      prefsObject.setString('userStory', '');
      prefsObject.setString('gender', '');
      prefsObject.setString('age', '');
      prefsObject.setString('location', '');
      prefsObject.setString('workingIn', '');
      prefsObject.setString('userSince', DateTime.now().toString());
      result = true;
    });
    return [result, error];
  }

  @override
  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
//    final FacebookLogin facebookLogin = FacebookLogin();
//    await facebookLogin.logOut();
    await prefsObject.clear();
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
