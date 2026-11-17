import 'package:flutter/foundation.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';

/// Keeps native calls outside the pages and allows navigation to be tested.
abstract class DuoPlatform {
  bool get isSupported;
  Stream<DuoFoldSnapshot> get folds;
  Stream<void> get backPresses;
  Future<ItchiSideBackStatus> setBackVisible(bool visible);
}

class PluginDuoPlatform implements DuoPlatform {
  @override
  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Stream<DuoFoldSnapshot> get folds => ItchiDuoFold.snapshots;

  @override
  Stream<void> get backPresses => ItchiDuoSideBack.onBack;

  @override
  Future<ItchiSideBackStatus> setBackVisible(bool visible) =>
      ItchiDuoSideBack.setVisible(visible);
}
