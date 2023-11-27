import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/collection/routes.dart';
import 'package:take_a_break/utils/persisted_state_notifier.dart';
import 'package:window_manager/window_manager.dart';

class BreakState {
  final Duration duration;
  final Duration breakDuration;

  BreakState({
    required this.duration,
    required this.breakDuration,
  }) : assert(duration.inSeconds > 0 && breakDuration.inSeconds > 0);

  BreakState copyWith({
    Duration? duration,
    Duration? breakDuration,
  }) {
    return BreakState(
      duration: duration ?? this.duration,
      breakDuration: breakDuration ?? this.breakDuration,
    );
  }

  factory BreakState.initial() {
    return BreakState(
      duration: const Duration(hours: 1),
      breakDuration: const Duration(minutes: 5),
    );
  }

  factory BreakState.fromJson(Map<String, dynamic> json) {
    return BreakState(
      duration: Duration(seconds: json['duration']),
      breakDuration: Duration(seconds: json['breakDuration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inSeconds,
      'breakDuration': breakDuration.inSeconds,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BreakState &&
        other.duration == duration &&
        other.breakDuration == breakDuration;
  }

  @override
  int get hashCode => duration.hashCode ^ breakDuration.hashCode;
}

class BreakNotifier extends PersistedStateNotifier<BreakState?> {
  final Ref ref;

  BreakNotifier(this.ref) : super(null, "break-state") {
    Timer? timer;
    Timer? breakTimer;
    Duration? lastDuration = state?.duration;
    addListener((state) {
      if (state == null) {
        timer?.cancel();
        breakTimer?.cancel();
        return;
      }
      if (state.duration != lastDuration) {
        timer?.cancel();
        breakTimer?.cancel();
        lastDuration = state.duration;
        timer = Timer.periodic(state.duration, (timer) async {
          await showBreakPage();
          breakTimer = Timer(state.breakDuration, hideBreakPage);
        });
      }
    });
  }

  Future<void> showBreakPage() async {
    final router = ref.read(routerProvider);
    router.go("/break");
    await windowManager.setFullScreen(true);
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAlwaysOnTop(true);
  }

  Future<void> hideBreakPage() async {
    final router = ref.read(routerProvider);
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setFullScreen(false);
    await windowManager.hide();
    await windowManager.blur();
    router.go("/home");
  }

  void setState(BreakState state) {
    this.state = state;
  }

  void reset() {
    state = BreakState.initial();
  }

  @override
  FutureOr<void> onInit() {
    ref.read(routerProvider).go("/");
  }

  @override
  FutureOr<BreakState?> fromJson(Map<String, dynamic> json) {
    try {
      return BreakState.fromJson(json);
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return state?.toJson() ?? {};
  }
}

final breakProvider = StateNotifierProvider<BreakNotifier, BreakState?>(
  (ref) => BreakNotifier(ref),
);
