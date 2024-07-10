import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

class FileEncryptor {
  final encrypt.Key key;
  final encrypt.IV iv;
  final encrypt.Encrypter encrypter;

  FileEncryptor(this.key, this.iv) : encrypter = encrypt.Encrypter(encrypt.AES(key));

  Future<void> encryptFile(File file, String destinationPath) async {
    final fileContents = await file.readAsBytes();
    final encryptedBytes = encrypter.encryptBytes(fileContents, iv: iv).bytes;
    await File(destinationPath).writeAsBytes(encryptedBytes);
  }

  Future<void> decryptFile(String encryptedFilePath, String destinationPath) async {
    final fileContents = await File(encryptedFilePath).readAsBytes();
    final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(fileContents), iv: iv);
    await File(destinationPath).writeAsBytes(decryptedBytes);
  }

  Future<String> encryptRecording(String originalPath) async {
    final File originalFile = File(originalPath);
    final encryptedFilePath = "$originalPath.enc";
    await encryptFile(originalFile, encryptedFilePath);
    await originalFile.delete();
    return encryptedFilePath;
  }
}
