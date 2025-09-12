import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';
import 'package:hr_attendance_tracker/services/profile_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ProfileService _profileService = ProfileService();

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      final profileExist = await _profileService.checkUserExists(user!.uid);

      if (!profileExist) {
        final profile = Profile(
          employeeId: user.uid,
          email: user.email!,
          name: user.email!.split('@')[0],
          role: 'employee',
        );

        await _profileService.createUserProfile(profile);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Sign in failed";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
