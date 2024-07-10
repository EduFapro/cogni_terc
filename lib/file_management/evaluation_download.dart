import 'dart:io';
import 'package:path/path.dart' as path;

Future<String> getDownloadsFolderPath() async {
  final String homeDirectory = Platform.environment['USERPROFILE'] ?? '';
  final String downloadsPath = path.join(homeDirectory, 'Downloads');
  return downloadsPath;
}

String generateFolderName(String evaluatorId, String participantId) {
  return 'A${evaluatorId.padLeft(2, '0')}P${participantId.padLeft(2, '0')}';
}

Future<String> createDownloadFolder(String evaluatorId, String participantId) async {
  final downloadsPath = await getDownloadsFolderPath();
  final folderName = generateFolderName(evaluatorId, participantId);
  final folderPath = path.join(downloadsPath, folderName);
  final directory = Directory(folderPath);
  if (!await directory.exists()) {
    await directory.create();
  }
  return folderPath;
}
