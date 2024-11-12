import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;

  User? get user => _user;

  // Check if user is already signed in
  Future<void> checkCurrentUser() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during registration';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
      }

      throw errorMessage;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during sign in';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled';
          break;
      }

      throw errorMessage;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in process
      if (googleUser == null) {
        throw 'Google sign in cancelled by user';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      _user = result.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during Google sign in';

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with this email';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign in is not enabled';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email';
          break;
      }

      throw errorMessage;
    } catch (e) {
      if (e is String) {
        throw e;
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _user = null;
      notifyListeners();
    } catch (e) {
      throw 'An error occurred while signing out';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred while resetting password';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email';
          break;
      }

      throw errorMessage;
    } catch (e) {
      rethrow;
    }
  }
}
