import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:take_a_break/collection/routes.dart';
import 'package:take_a_break/utils/persisted_state_notifier.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appSupportDir = await getApplicationSupportDirectory();
  await Hive.initFlutter(appSupportDir.path);
  await PersistedStateNotifier.initializeBoxes(path: appSupportDir.path);

  if (kReleaseMode) {
    launchAtStartup.setup(
      appName: 'Take A Break',
      appPath: Platform.resolvedExecutable,
    );

    if (!await launchAtStartup.isEnabled()) {
      await launchAtStartup.enable();
    }
  }

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Take A Break bro!',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: TakeABreak()));
}

class TakeABreak extends HookConsumerWidget {
  const TakeABreak({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return DragToResizeArea(child: child!);
      },
    );
  }
}
