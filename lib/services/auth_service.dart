import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class AuthService {
  Future<void> signInEmailPassword({
    required email,
    required password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createEmailPassword({
    required email,
    required username,
    required password,
    required image,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final storageRef = FirebaseStorage.instance
          .ref()
          .child(credential.user!.uid)
          .child(path.basename(image.path));
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(
        {
          'username': username,
          'email': email,
          'image_url': imageUrl,
        },
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
