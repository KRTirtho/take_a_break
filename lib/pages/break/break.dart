import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/providers/break_provider.dart';

class BreakPage extends HookConsumerWidget {
  const BreakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);
    final breakState = ref.watch(breakProvider);
    final streamController = useStreamController<int>();

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        streamController.add(timer.tick);
      });

      return timer.cancel;
    }, []);

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/breakdance.gif",
                width: 200,
                color: colorScheme.primaryContainer,
                colorBlendMode: BlendMode.multiply,
              ),
            ),
            const Gap(16),
            Text(
              "Time to take a break!",
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.grey[850],
              ),
            ),
            StreamBuilder<int>(
              stream: streamController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                final remainingBreak = breakState!.breakDuration -
                    Duration(seconds: snapshot.data!);

                final seconds = (remainingBreak.inSeconds % 60)
                    .toInt()
                    .toString()
                    .padLeft(2, "0");
                final minutes = (remainingBreak.inMinutes % 60)
                    .toInt()
                    .toString()
                    .padLeft(2, "0");

                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(text: "You've got\n"),
                      TextSpan(
                        text: "$minutes:$seconds",
                        style: textTheme.displayMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                      const TextSpan(text: "\ntime left of your break."),
                    ],
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.grey[850],
                    ),
                  ),
                );
              },
            ),
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(breakProvider.notifier).hideBreakPage();
                  },
                  child: const Text("Hide"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
