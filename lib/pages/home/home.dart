import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/extensions/theme.dart';
import 'package:take_a_break/modules/home/form.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    return Scaffold(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/refreshing_beverage.png",
                  width: 200,
                  height: 200,
                  color: colorScheme.imageBlend,
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
              Text(
                "Yo, who's that tough fella?! Oh, it's you!",
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.baseText,
                ),
              ),
              Text(
                "Looks like you're taking breaks. Bravo!!\n"
                "Btw, you can re-configure your breaks here now",
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.subtitleText,
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
