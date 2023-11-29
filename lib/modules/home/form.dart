import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/extensions/theme.dart';
import 'package:take_a_break/providers/break_provider.dart';

class HomePageForm extends HookConsumerWidget {
  const HomePageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    final breakState = ref.watch(breakProvider);
    final breakNotifier = ref.watch(breakProvider.notifier);

    final durationController = useTextEditingController(
      text: breakState?.duration.inHours.toString(),
    );

    final breakDurationController = useTextEditingController(
      text: breakState?.breakDuration.inMinutes.toString(),
    );

    const inputDecoration = InputDecoration(
      enabledBorder: InputBorder.none,
      counterText: "",
      isDense: true,
      hintText: "1",
      errorMaxLines: 2,
      suffixIconConstraints: BoxConstraints(
        minWidth: 0,
        minHeight: 0,
      ),
      prefixIconConstraints: BoxConstraints(
        minWidth: 0,
        minHeight: 0,
      ),
    );

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: textTheme.titleMedium!.copyWith(
              color: colorScheme.subtitleText,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 60,
                  child: TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 1,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Write something bruh!";
                      } else if (int.parse(text) < 1) {
                        return "You're not working at all! Keep it above 1 hour!";
                      } else if (int.parse(text) > 4) {
                        return "Too much! You're gonna die over-working fella!\nKeep it under 4 hours!";
                      }
                      return null;
                    },
                    decoration: inputDecoration.copyWith(
                      prefixIcon: const Text("Remind me every "),
                      suffixIcon: const Text(" hour(s),"),
                    ),
                  ),
                ),
                const Gap(5),
                SizedBox(
                  height: 60,
                  width: 230,
                  child: TextFormField(
                    controller: breakDurationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 2,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Yo, you gotta right something!";
                      } else if (int.parse(text) < 4) {
                        return "WTH? You call it a break?! Keep it above 4 minutes!";
                      } else if (int.parse(text) > 10) {
                        return "Hey, seriously, procrastination?! Keep it under 10 minutes!";
                      }
                      return null;
                    },
                    decoration: inputDecoration.copyWith(
                      hintText: "5",
                      prefixIcon: const Text("to take a break for "),
                      suffixIcon: const Text(" minutes"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(50),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: breakState == null
                ? const Text("Start a good life!")
                : const Text("Re-start a good life?"),
            onPressed: () {
              final isValid = formKey.currentState?.validate();
              if (isValid != true) return;

              breakNotifier.setState(
                BreakState(
                  duration: Duration(
                    hours: int.parse(durationController.text),
                  ),
                  breakDuration: Duration(
                    minutes: int.parse(breakDurationController.text),
                  ),
                ),
              );

              context.push("/all-set");
            },
          ),
        ],
      ),
    );
  }
}
