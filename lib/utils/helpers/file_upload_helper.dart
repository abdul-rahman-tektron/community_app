import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from camera or gallery
  static Future<File?> pickImage({bool fromCamera = false}) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) return null;
    return await _saveToPermanentDirectory(File(pickedFile.path));
  }

  /// Pick image or video from gallery only
  static Future<File?> pickImageOrVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi', 'mkv'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return null;
    final path = result.files.single.path;
    if (path == null) return null;
    return await _saveToPermanentDirectory(File(path));
  }

  /// Save to app's documents directory with unique name
  static Future<File> _saveToPermanentDirectory(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
    final savedPath = '${appDir.path}/$fileName';
    return await file.copy(savedPath);
  }

  static Future<File> base64ToFile(String base64Str, {required String fileName}) async {
    final bytes = base64Decode(base64Str);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
