import 'package:emotion_music_app/services/auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthAction { signIn, signUp }

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
}

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> _authWithEmailPassword({
    required String email,
    required String password,
    required AuthAction action,
  }) async {
    try {
      UserCredential? userCredential;

      if (action == AuthAction.signIn) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (action == AuthAction.signUp) {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      return userCredential?.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw AuthException(
          message: "The email address is not valid",
          code: e.code,
        );
      } else if (e.code == "user-disabled") {
        throw AuthException(
          message: "This user has been disabled.",
          code: e.code,
        );
      } else if (e.code == 'user-not-found') {
        throw AuthException(
          message: 'No user found for that email.',
          code: e.code,
        );
      } else if (e.code == 'wrong-password') {
        throw AuthException(message: 'Wrong password.', code: e.code);
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(
          message: 'The email address is already in use by another account.',
          code: e.code,
        );
      } else if (e.code == 'weak-password') {
        throw AuthException(message: 'The password is too weak.', code: e.code);
      } else {
        throw AuthException(
          message: 'An unknown error occurred: ${e.message}',
          code: e.code,
        );
      }
    } catch (e) {
      throw AuthException(message: "An error occured", code: e.toString());
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = _authWithEmailPassword(
      email: email,
      password: password,
      action: AuthAction.signUp,
    );

    return user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _authWithEmailPassword(
      email: email,
      password: password,
      action: AuthAction.signIn,
    );
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: "ERROR_ABORTED_BY_USER",
          message: "Sign in aborted by user",
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      throw AuthException(message: "Google sign in failed", code: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      throw AuthException(message: "Failed to sign out", code: e.toString());
    }
  }
}
