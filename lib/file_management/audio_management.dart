import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../app/recording_file/recording_file_entity.dart';
import 'file_encryptor.dart';

Future<String> renameAndSaveRecording({
  required String originalPath,
  required int evaluatorId,
  required int participantId,
  required int taskInstanceId,
  required Function(RecordingFileEntity) saveRecordingCallback,
}) async {
  final FileEncryptor fileEncryptor = Get.find<FileEncryptor>();
  final dateString = DateFormat('ddMMyyyy').format(DateTime.now());
  final formattedFileName = 'A${evaluatorId.toString().padLeft(2, '0')}_P${participantId.toString().padLeft(2, '0')}_T${taskInstanceId}_$dateString.aac';
  final newPath = path.join(path.dirname(originalPath), formattedFileName);

  // First, rename the original file
  final renamedFilePath = await File(originalPath).rename(newPath).then((file) => file.path);

  // Now, encrypt the renamed file and get the path with .enc
  final encryptedFilePath = await fileEncryptor.encryptRecording(renamedFilePath);

  final recording = RecordingFileEntity(
    taskInstanceId: taskInstanceId,
    filePath: encryptedFilePath, // Make sure to save the path of the encrypted file
  );

  await saveRecordingCallback(recording);
  return encryptedFilePath; // Return the path of the encrypted file
}



Future<String> getApplicationDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> getTemporaryDirectoryPath() async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}


Future<String> saveAudioFile(ByteData data, String tempFileName, int evaluatorId,
    int participantId, int taskInstanceId) async {
  // Log the invocation of the function with the temporary file name.
  print('saveAudioFile called with tempFileName: $tempFileName');

  // Obtain the directory path for the application's documents directory.
  final String dirPath = await getApplicationDocumentsPath();

  // Create a Directory object pointing to 'Cognivoice' subdirectory within the documents directory.
  final Directory mySubDir = Directory(path.join(dirPath, 'Cognivoice'));

  // Check if the 'Cognivoice' directory exists, and if not, create it along with any non-existent parent directories.
  if (!await mySubDir.exists()) {
    await mySubDir.create(recursive: true);
  }

  // Format evaluatorId and participantId to have at least 2 digits with leading zeros if necessary.
  final String formattedEvaluatorId = evaluatorId.toString().padLeft(2, '0');
  final String formattedParticipantId = participantId.toString().padLeft(2, '0');

  // Format the current date as a string in 'ddMMyyyy' format.
  final String recordingDate = DateFormat('ddMMyyyy').format(DateTime.now());

  // Construct a unique file name using the formatted evaluator and participant IDs, task instance ID, and the current date.
  final String fileName = 'A${formattedEvaluatorId}_P${formattedParticipantId}_AT${taskInstanceId}_$recordingDate.aac';

  // Use the path package's join method to concatenate the directory path and file name,
  // ensuring the correct path separators are used for the platform.
  final String filePath = path.join(mySubDir.path, fileName);

  // Create a File object pointing to the intended file path and use it to write the audio data.
  final File file = File(filePath);
  print('Saving audio file at: $filePath');
  await file.writeAsBytes(data.buffer.asUint8List());

  // Optionally, check if a temporary file exists and delete it if it does.
  final File tempFile = File(path.join(mySubDir.path, tempFileName));
  if (await tempFile.exists()) {
    await tempFile.delete();
    print('Deleted temporary file: $tempFileName');
  }

  // Return the full file path where the audio file was saved.
  return filePath;
}


Future<String> getSecureStoragePath() async {
  // Retrieve the user profile directory path from the system environment variables.
  final String userDirectory = Platform.environment['USERPROFILE'] ?? '';

  // If the 'USERPROFILE' environment variable is not found, userDirectory will default to an empty string.

  // Use the path package's join method to construct the path for '.MySecureAppData' directory
  // within the user profile directory, ensuring the use of correct directory separators.
  final secureDirPath = path.join(userDirectory, '.MySecureAppData');

  // Create a Directory object pointing to the path for '.MySecureAppData'.
  final Directory secureDir = Directory(secureDirPath);

  // Check if the '.MySecureAppData' directory exists in the user's profile directory.
  // If it does not exist, create it.
  if (!await secureDir.exists()) {
    await secureDir.create();
    // The 'create' method will create the directory if it doesn't exist.
  }

  // Return the path to the '.MySecureAppData' directory.
  return secureDir.path;
}

