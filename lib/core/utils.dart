import 'package:flutter/material.dart';

import 'package:client/core/core.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Pallete.gradient1,
      ),
    );
}
