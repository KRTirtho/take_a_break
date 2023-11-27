import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/modules/home/form.dart';
import 'package:take_a_break/providers/break_provider.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "So how's your day going? Lol, must be good! You're taking breaks after all",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/refreshing_beverage.png",
                width: 200,
                height: 200,
                color: colorScheme.primaryContainer,
                colorBlendMode: BlendMode.multiply,
              ),
              Text(
                "Yo, who's that tough fella?! Oh, it's you!",
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.grey[850],
                ),
              ),
              Text(
                "Looks like you're taking breaks. Bravo!!\n"
                "Btw, you can re-configure your breaks here now",
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(40),
              const HomePageForm(),
            ],
          ),
        ),
      ),
    );
  }
}
