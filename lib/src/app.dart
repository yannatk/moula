import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moula/src/routing/app_router.dart';
import 'package:moula/src/shared/util/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Moula',
      theme: AppTheme().theme,
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
