import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/providers/break_provider.dart';

class AllSetPage extends HookConsumerWidget {
  const AllSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakState = ref.watch(breakProvider);
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/playful_cat.png",
              width: 500,
              color: colorScheme.primaryContainer,
              colorBlendMode: BlendMode.multiply,
            ),
            Text(
              "You're all set!",
              style: textTheme.headlineMedium,
            ),
            Text(
              "You'll be notified every ${breakState?.duration.inHours} hour(s) to take a break for ${breakState?.breakDuration.inMinutes} minutes.",
              style: textTheme.bodyLarge,
            ),
            const Gap(16),
            FilledButton(
              onPressed: () {
                context.go("/");
              },
              child: const Text("Got it!"),
            ),
          ],
        ),
      ),
    );
  }
}
