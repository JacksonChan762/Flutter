import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum PhotoSource { camera, gallery }

enum PhotoPickStatus { picked, denied, failed }

class PhotoPickResult {
  const PhotoPickResult(this.status, {this.path});
  final PhotoPickStatus status;
  final String? path;
}

/// Asks for the permission that matches the source, then opens the picker.
class PhotoPickerService {
  PhotoPickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;

  Future<bool> requestPermission(PhotoSource source) async {
    final permission = source == PhotoSource.camera
        ? Permission.camera
        : Permission.photos;
    var status = await permission.status;
    if (status.isGranted || status.isLimited) return true;
    status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  Future<PhotoPickResult> pick(PhotoSource source) async {
    if (!await requestPermission(source)) {
      return const PhotoPickResult(PhotoPickStatus.denied);
    }
    try {
      final file = await _picker.pickImage(
        source: source == PhotoSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return const PhotoPickResult(PhotoPickStatus.failed);
      return PhotoPickResult(PhotoPickStatus.picked, path: file.path);
    } catch (_) {
      return const PhotoPickResult(PhotoPickStatus.failed);
    }
  }

  Future<bool> openSettings() => openAppSettings();
}
