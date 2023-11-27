import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/modules/home/form.dart';

class SetupPage extends HookConsumerWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "This project was made with breaks. A lot of breaks!",
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
                "assets/office_snack.png",
                width: 200,
                height: 200,
                color: colorScheme.primaryContainer,
                colorBlendMode: BlendMode.multiply,
              ),
              Text(
                "Take a break, Pal!",
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.grey[850],
                ),
              ),
              const Gap(20),
              const HomePageForm(),
            ],
          ),
        ),
      ),
    );
  }
}
