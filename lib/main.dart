import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/core.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/features.dart';
import 'package:client/features/home/view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final notifier = container.read(authViewModelProvider.notifier);
  await notifier.initSharedPreferences();
  await notifier.getData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      home: currentUser != null ? const HomePage() : const SigninPage(),
    );
  }
}
