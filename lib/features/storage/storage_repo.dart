import 'dart:typed_data';

abstract class StorageRepo {
  // for profile image 
  Future<String?> uploadProfileImageWeb(Uint8List imageBytes, String fileName);
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // for post image 
    Future<String?> uploadPostImageWeb(Uint8List imageBytes, String fileName);
  Future<String?> uploadPostImageMobile(String path, String fileName);
}
