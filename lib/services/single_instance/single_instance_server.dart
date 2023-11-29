import 'dart:convert';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

Future<void> start() async {
  final app = Alfred();

  app.get('/ping', (req, res) {
    res.json({'message': 'pong'});
  });

  app.get('/show', (req, res) async {
    await windowManager.show();
    await windowManager.focus();
    res.json({'message': 'ok'});
  });

  await app.listen(37201);
}

Future<bool> isRunning() async {
  try {
    final res = await http.get(Uri.parse('http://localhost:37201/ping'));

    final data = jsonDecode(res.body);

    return res.statusCode == 200 && data['message'] == 'pong';
  } on Exception {
    return false;
  }
}

Future<void> ensureSingleInstance() async {
  final running = await isRunning();
  if (running && !Platform.executableArguments.contains('--headless')) {
    await http.get(Uri.parse('http://localhost:37201/show'));
  } else if (!running) {
    await start();
  }
}
