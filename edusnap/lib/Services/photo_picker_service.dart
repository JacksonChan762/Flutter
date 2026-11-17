import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum PhotoSource { camera, gallery }

enum PhotoPickStatus { picked, cancelled, denied, failed }

class PhotoPickResult {
  const PhotoPickResult(this.status, {this.path});
  final PhotoPickStatus status;
  final String? path;
}

/// Asks for the permission that matches the source, then opens the picker.
class PhotoPickerService {
  PhotoPickerService({ImagePicker? picker, Future<int> Function()? androidSdk})
    : _picker = picker ?? ImagePicker(),
      _androidSdk =
          androidSdk ??
          (() async => (await DeviceInfoPlugin().androidInfo).version.sdkInt);
  final ImagePicker _picker;
  final Future<int> Function() _androidSdk;

  Future<bool> requestPermission(PhotoSource source) async {
    var permission = source == PhotoSource.camera
        ? Permission.camera
        : Permission.photos;
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        source == PhotoSource.gallery &&
        await _androidSdk() < 33) {
      permission = Permission.storage;
    }
    var status = await permission.status;
    if (status.isGranted || status.isLimited) return true;
    status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  Future<PhotoPickResult> pick(PhotoSource source) async {
    try {
      if (!await requestPermission(source)) {
        return const PhotoPickResult(PhotoPickStatus.denied);
      }
      final file = await _picker.pickImage(
        source: source == PhotoSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return const PhotoPickResult(PhotoPickStatus.cancelled);
      return PhotoPickResult(PhotoPickStatus.picked, path: file.path);
    } catch (_) {
      return const PhotoPickResult(PhotoPickStatus.failed);
    }
  }

  Future<bool> openSettings() => openAppSettings();
}
