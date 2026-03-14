import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _ensureUserDocument(credential.user);
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _ensureUserDocument(credential.user);
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _ensureUserDocument(User? user) async {
    if (user == null) return;
    
    final docRefs = _firestore.collection('users').doc(user.uid);
    final doc = await docRefs.get();
    
    if (!doc.exists) {
      await docRefs.set({
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      await docRefs.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }
}
