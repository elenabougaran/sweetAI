import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/providers/auth_providers.dart';

final authViewModelProvider = Provider<AuthViewModel>((ref) {
  return AuthViewModel(ref.watch(firebaseAuthProvider));
});


class AuthViewModel {
  AuthViewModel(this._auth);

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté');

    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred);
  }

  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté');

    await user.verifyBeforeUpdateEmail(newEmail);
    // recharger l'utilisateur pour être sûr d'avoir les infos à jour
    await user.reload();
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
