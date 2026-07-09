import 'package:flutter/material.dart';
import 'package:move_your_body/core/routing/app_router.dart';

import 'core/theme/app_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/db_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseService.instance.database;
  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
