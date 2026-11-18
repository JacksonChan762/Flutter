import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';

/// Keeps native calls outside the pages and allows navigation to be tested.
abstract class DuoPlatform {
  bool get isSupported;
  Stream<DuoFoldSnapshot> get folds;
  Stream<void> get backPresses;
  Future<ItchiSideBackStatus> setBackVisible(bool visible);
}

class PluginDuoPlatform implements DuoPlatform {
  static const _railChannel = MethodChannel(
    'itchi_flutter_duo_layout/side_back',
  );
  static final _backEvents = StreamController<void>.broadcast(
    onListen: () => _railChannel.setMethodCallHandler(_handleRailCallback),
    onCancel: () => _railChannel.setMethodCallHandler(null),
  );

  static Future<void> _handleRailCallback(MethodCall call) async {
    // The native plugin sends both onItemTap and the legacy onBack for Back.
    // EduSnap uses setItems, so only the modern tap callback triggers a pop.
    if (call.method != 'onItemTap') return;
    final arguments = call.arguments;
    final id = arguments is Map ? arguments['id'] : arguments;
    if (id == ItchiRailItem.backId) _backEvents.add(null);
  }

  @override
  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Stream<DuoFoldSnapshot> get folds => ItchiDuoFold.snapshots;

  @override
  Stream<void> get backPresses => _backEvents.stream;

  @override
  Future<ItchiSideBackStatus> setBackVisible(bool visible) async {
    try {
      final result = await _railChannel.invokeMethod<Object?>('setItems', {
        'items': [if (visible) ItchiRailItem.back().toMessage()],
      });
      if (result is! Map) return ItchiSideBackStatus.unknown;
      final status = result['status'];
      return ItchiSideBackStatus.values.firstWhere(
        (value) => value.name == status,
        orElse: () => ItchiSideBackStatus.unknown,
      );
    } on MissingPluginException {
      return ItchiSideBackStatus.unsupportedPlatform;
    } on PlatformException {
      return ItchiSideBackStatus.viewUnavailable;
    }
  }
}
