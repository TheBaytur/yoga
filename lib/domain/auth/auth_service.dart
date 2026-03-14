import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Stream<User?> authStateChanges() => _auth.authStateChanges();

  static Future<UserCredential> signInWithEmail(
    String email,
    String password,
  ) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _upsertUserProfile(credential);
    return credential;
  }

  static Future<UserCredential> signUpWithEmail(
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _upsertUserProfile(credential);
    return credential;
  }

  static Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign_in_canceled',
        message: 'Google sign-in was canceled.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final oauthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final credential = await _auth.signInWithCredential(oauthCredential);
    await _upsertUserProfile(credential, provider: 'google');
    return credential;
  }

  static Future<UserCredential> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

    final credential = await _auth.signInWithCredential(oauthCredential);

    final fullName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].where((value) => value != null && value.isNotEmpty).join(' ');

    if (fullName.isNotEmpty && credential.user != null) {
      await credential.user!.updateDisplayName(fullName);
    }

    await _upsertUserProfile(credential, provider: 'apple');
    return credential;
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  static Future<void> _upsertUserProfile(
    UserCredential credential, {
    String? provider,
  }) async {
    final user = credential.user;
    if (user == null) return;

    final isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

    final data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'provider':
          provider ?? user.providerData.map((p) => p.providerId).toList(),
      'lastSignInAt': FieldValue.serverTimestamp(),
    };

    if (isNewUser) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await _db
        .collection('users')
        .doc(user.uid)
        .set(data, SetOptions(merge: true));
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
