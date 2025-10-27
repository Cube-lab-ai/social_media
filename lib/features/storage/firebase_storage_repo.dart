import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_firebase/features/storage/storage_repo.dart';

class FirebaseStorageRepo extends StorageRepo {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImageWeb(
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      final storageref = _storage.ref('/profile_images/$fileName');
      await storageref.putData(imageBytes);
      final result = await storageref.getDownloadURL();
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    try {
      final file = File(path);
      final storageref = _storage.ref('/profile_images/$fileName');
      // What Happens Internally

      // Flutter reads the local file (File object).
      // Firebase SDK uploads it in chunks to Google Cloud Storage.
      // Once done, Firebase returns a UploadTask or a completion response.

      // What putFile() Does Internally

      // The putFile() method from the Firebase SDK takes your File object and internally uses the Dart File.openRead() method to read the file’s contents as a byte stream.
      // That stream is then uploaded (chunk by chunk) to Firebase’s cloud storage service.
      // So conceptually, Firebase does something equivalent to this under the hood:

      // final stream = file.openRead();          // ← reads file as byte stream
      // final length = await file.length();      // ← gets file size
      // firebaseUploader.uploadStream(stream, length);  // ← uploads to Firebase
      await storageref.putFile(file);
      final result = await storageref.getDownloadURL();
      return result;
    } catch (e) {
      return null;
    }
  }

  // for post image
  @override
  Future<String?> uploadPostImageWeb(
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      final storageref = _storage.ref('/post_images/$fileName');
      await storageref.putData(imageBytes);
      final result = await storageref.getDownloadURL();
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadPostImageMobile(String? path, String fileName) async {
    try {
      final file = File(path!);
      final storageref = _storage.ref('/post_images/$fileName');
      await storageref.putFile(file);
      final result = await storageref.getDownloadURL();
      return result;
    } catch (e) {
      return null;
    }
  }
}
