import 'dart:io';

import 'package:flutter/services.dart';

Future<void> paste() async {
  var text = await getClipboardData();
  // print(text);
  final res = await Process.run('py/superpaste-py.exe', [text]);
  print(res);

}

Future<String> getClipboardData() async {
  ClipboardData? data = await Clipboard.getData('text/plain');
  return "${data?.text}";
}
