import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';

class AuthService extends AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = locator<FirestoreServiceInterface>();

  @override
  Future<Client> getCurrentUser() async {
    var user = await _auth.currentUser();
    if (user == null) return null;
    return await _firestore.getClient(user.uid);
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    if (await isUserLoggedIn()) {
      await _auth.signOut();
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    var user = await getCurrentUser();
    return user != null;
  }
}
