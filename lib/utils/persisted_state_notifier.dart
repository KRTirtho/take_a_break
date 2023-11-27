import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

abstract class PersistedStateNotifier<T> extends StateNotifier<T> {
  final String cacheKey;

  FutureOr<void> onInit() {}

  PersistedStateNotifier(
    super.state,
    this.cacheKey,
  ) {
    _load().then((_) => onInit());
  }

  static late LazyBox _box;

  static Future<void> initializeBoxes({required String? path}) async {
    _box = await Hive.openLazyBox(
      "take_a_break_cache",
      path: path,
    );
  }

  LazyBox get box => _box;

  Future<void> _load() async {
    final json = await box.get(cacheKey);

    if (json != null) {
      state = await fromJson(castNestedJson(json));
    }
  }

  Map<String, dynamic> castNestedJson(Map map) {
    return Map.castFrom<dynamic, dynamic, String, dynamic>(
      map.map((key, value) {
        if (value is Map) {
          return MapEntry(
            key,
            castNestedJson(value),
          );
        } else if (value is Iterable) {
          return MapEntry(
            key,
            value.map((e) {
              if (e is Map) return castNestedJson(e);
              return e;
            }).toList(),
          );
        }
        return MapEntry(key, value);
      }),
    );
  }

  void save() async {
    await box.put(cacheKey, toJson());
  }

  FutureOr<T> fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  @override
  set state(T value) {
    if (state == value) return;
    super.state = value;
    save();
  }
}
