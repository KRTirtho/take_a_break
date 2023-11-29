import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/extensions/theme.dart';
import 'package:take_a_break/modules/shell/page_window_title_bar.dart';
import 'package:take_a_break/providers/break_provider.dart';

class ShellPage extends HookConsumerWidget {
  final Widget child;
  const ShellPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.isDarkMode ? null : theme.colorScheme.primaryContainer,
      extendBodyBehindAppBar: true,
      appBar: PageWindowTitleBar(
        backgroundColor: Colors.transparent,
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: () {
                ref.read(breakProvider.notifier).showBreakPage();
              },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
          if (kDebugMode)
            IconButton(
              onPressed: () {
                ref.read(breakProvider.notifier).hideBreakPage();
              },
              icon: const Icon(Icons.pause_rounded),
            ),
          if (kDebugMode)
            IconButton(
              onPressed: () {
                context.go("/break");
              },
              icon: const RotatedBox(
                quarterTurns: 2,
                child: Icon(Icons.navigate_before),
              ),
            ),
        ],
      ),
      body: child,
    );
  }
}
