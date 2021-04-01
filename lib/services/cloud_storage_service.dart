import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadFile({
    @required File fileToUpload,
    @required String title,
  }) async {
    var fileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    final Reference ref =
        FirebaseStorage.instance.ref().child('images').child(fileName);

    UploadTask uploadTask = ref.putFile(fileToUpload);

    TaskSnapshot snapshot = uploadTask.snapshot;

    var downloadUrl = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      var fileUrl = downloadUrl.toString();
      return CloudStorageResult(
        fileUrl: fileUrl,
        fileName: fileName,
      );
    }

    return null;
  }

  Future deleteImage(String fileName) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child(fileName);

    try {
      await reference.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class CloudStorageResult {
  final String fileUrl;
  final String fileName;

  CloudStorageResult({this.fileUrl, this.fileName});
}
