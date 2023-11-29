import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatheticDialog extends HookConsumerWidget {
  const PatheticDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return AlertDialog.adaptive(
      title: const Text("Seriously? What do you think, I'm that dumb?🤦"),
      content: const Text(
        "You're being so desparate to work, it is pathetic. Take a break! You can't fool me!",
      ),
      actions: [
        if (Platform.isMacOS)
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("I'm sorry, I'll take a break"),
          )
        else
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("I'm sorry, I'll take a break"),
          ),
      ],
    );
  }
}
