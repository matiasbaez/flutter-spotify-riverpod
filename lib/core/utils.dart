import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:client/core/core.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Pallete.whiteColor,
          ),
        ),
        backgroundColor: Pallete.gradient1,
      ),
    );
}

// TODO: Configure https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#android
Future<File?> pickAudio() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null) {
      // final path = result.files.single.path;
      return File(result.files.first.xFile.path);
    }

    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // final path = result.files.single.path;
      return File(result.files.first.xFile.path);
    }

    return null;
  } catch (e) {
    return null;
  }
}

String rgbToHex(Color color) {
  final r = color.red.toRadixString(16).padLeft(2, '0');
  final g = color.green.toRadixString(16).padLeft(2, '0');
  final b = color.blue.toRadixString(16).padLeft(2, '0');
  return '$r$g$b';
  // return color.value.toRadixString(16);
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
