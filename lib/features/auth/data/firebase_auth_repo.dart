import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_firebase/features/auth/domain/entities/app_user.dart';
import 'package:social_media_firebase/features/auth/domain/repositories/auth_repo.dart';

class FirebaseAuthRepo extends AuthRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final DocumentSnapshot<Map<String, dynamic>> userdocument =
          await _firebaseFirestore
              .collection('users')
              .doc(result.user!.uid)
              .get();

      String? userName;
      if (userdocument.exists) {
        Map<String, dynamic>? userdata = userdocument.data();
        if (userdata != null) {
          userName = userdata['name'];
        }
      } else {
        return null;
      }

      return AppUser(
        uid: result.user!.uid,
        name: userName!,
        email: result.user!.email!,
      );
    } catch (e) {
      throw Exception("Login Failed $e");
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseFirestore.collection('users').doc(result.user!.uid).set({
        "uid": result.user!.uid,
        "name": name,
        "email": result.user!.email!,
      });

      return AppUser(
        uid: result.user!.uid,
        name: name,
        email: result.user!.email!,
      );
    } catch (e) {
      throw Exception('Login Failed $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> userdocument =
        await _firebaseFirestore.collection('users').doc(user.uid).get();

    String? userName;
    if (userdocument.exists) {
      Map<String, dynamic>? userdata = userdocument.data();
      if (userdata != null) {
        userName = userdata['name'];
      }
    } else {
      return null;
    }

    return AppUser(uid: user.uid, name: userName!, email: user.email!);
  }

  @override
  Future<void> logout() async {
    _firebaseAuth.signOut();
  }
}
