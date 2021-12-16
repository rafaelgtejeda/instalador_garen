import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCredencial(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Stream<User> get currentUserGoogle => _auth.authStateChanges();
  Future<void> logout() => _auth.signOut();

  Future<UserCredential> signInWithCredentail(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Stream<User> get currentUserFacebook => _auth.authStateChanges();
  Future<void> logoutFacebook() => _auth.signOut();

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Stream<User> get currentUserApple => _auth.authStateChanges();
  Future<void> logoutApple() => _auth.signOut();
}
