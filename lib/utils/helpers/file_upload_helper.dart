import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image (Trade License / ID) from camera or gallery
  static Future<File?> pickImage({
    bool fromCamera = false,
  }) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80, // Compress a bit for upload
    );

    if (pickedFile == null) return null;

    final File imageFile = File(pickedFile.path);
    return await _saveToPermanentDirectory(imageFile);
  }

  /// Save to app's documents directory with unique name
  static Future<File> _saveToPermanentDirectory(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
    final savedPath = '${appDir.path}/$fileName';
    return await file.copy(savedPath);
  }
}
