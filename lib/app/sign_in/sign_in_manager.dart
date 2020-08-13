import 'dart:async';

import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});

  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async {
    return await _signIn(auth.signInAnonymously);
  }

// TODO(marius): Third Party Login Removed due to restriction from App Store.
  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithApple() async {
    return await _signIn(auth.signInWithApple);
  }
//
//  Future<void> signInWithFacebook() async {
//    return await _signIn(auth.signInWithFacebook);
//  }
}
