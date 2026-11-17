import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';

import '../../Services/duo_platform.dart';

/// Coordinates the native rail with the entire route stack, including dialogs.
class DuoLayoutController extends ChangeNotifier with WidgetsBindingObserver {
  DuoLayoutController({DuoPlatform? platform})
    : _platform = platform ?? PluginDuoPlatform() {
    observer = _DuoNavigatorObserver(this);
  }

  final DuoPlatform _platform;
  final navigatorKey = GlobalKey<NavigatorState>();
  late final NavigatorObserver observer;
  StreamSubscription<DuoFoldSnapshot>? _foldSubscription;
  StreamSubscription<void>? _backSubscription;
  Future<void> _pending = Future<void>.value();
  bool _disposed = false;
  bool _started = false;
  bool _syncScheduled = false;
  bool _railActive = false;
  bool _fullScreen = false;

  bool get railActive => _railActive;
  bool get fullScreen => _fullScreen;

  void start() {
    if (_started || _disposed || !_platform.isSupported) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _backSubscription = _platform.backPresses.listen((_) {
      navigatorKey.currentState?.maybePop();
    });
    _foldSubscription = _platform.folds.listen(
      (snapshot) {
        _setFullScreen(snapshot.isAvailable && snapshot.wantsTwoPanes);
        scheduleSync();
      },
      onError: (Object error) {
        _setFullScreen(false);
        scheduleSync();
      },
    );
    scheduleSync();
  }

  void _setFullScreen(bool value) {
    if (_disposed || value == _fullScreen) return;
    _fullScreen = value;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) scheduleSync();
  }

  /// Wait until navigation has completed, then serialize native updates so a
  /// quick push/pop cannot leave a stale Back button on the home screen.
  void scheduleSync() {
    if (_disposed || !_started || _syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (_disposed) return;
      _pending = _pending.then((_) => _syncRail());
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _syncRail() async {
    if (_disposed) return;
    for (var attempt = 0; attempt < 2; attempt++) {
      if (_disposed) return;
      final canPop = navigatorKey.currentState?.canPop() ?? false;
      ItchiSideBackStatus status;
      try {
        status = await _platform.setBackVisible(canPop);
      } catch (_) {
        // Keep Flutter navigation usable if the native bridge fails.
        status = ItchiSideBackStatus.unknown;
      }
      if (_disposed) return;
      // Navigation may have changed while the native call was in flight.
      if (canPop != (navigatorKey.currentState?.canPop() ?? false)) {
        scheduleSync();
        return;
      }
      final active = canPop && status == ItchiSideBackStatus.available;
      if (active != _railActive) {
        _railActive = active;
        notifyListeners();
      }
      if (status != ItchiSideBackStatus.viewUnavailable || attempt == 1) {
        return;
      }
      // Retry once after the native view has had another frame to attach.
      // This stays in the serialized queue, including during disposal.
      await WidgetsBinding.instance.endOfFrame;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_foldSubscription?.cancel());
    unawaited(_backSubscription?.cancel());
    // Clear after any in-flight update, so it cannot re-enable a stale item.
    if (_started) {
      unawaited(
        _pending.then((_) async {
          try {
            await _platform.setBackVisible(false);
          } catch (_) {
            // Native view may already have been torn down.
          }
        }),
      );
    }
    super.dispose();
  }
}

class _DuoNavigatorObserver extends NavigatorObserver {
  _DuoNavigatorObserver(this.controller);
  final DuoLayoutController controller;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      controller.scheduleSync();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      controller.scheduleSync();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      controller.scheduleSync();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      controller.scheduleSync();
}

class DuoLayoutScope extends InheritedNotifier<DuoLayoutController> {
  const DuoLayoutScope({
    super.key,
    required DuoLayoutController controller,
    required super.child,
  }) : super(notifier: controller);

  static bool railActiveOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DuoLayoutScope>()
          ?.notifier
          ?.railActive ??
      false;

  static double contentWidthOf(BuildContext context) =>
      (context
              .dependOnInheritedWidgetOfExactType<DuoLayoutScope>()
              ?.notifier
              ?.fullScreen ??
          false)
      ? double.infinity
      : 720;
}
