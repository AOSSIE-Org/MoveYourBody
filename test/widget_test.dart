import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/model/user_data.dart';
import 'package:move_your_body/features/onboarding/view/splash_screen.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';

class FakeDatabase extends Fake implements Database {
  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    if (sql.contains('COUNT(*)')) return [{'count': 1}];
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => [];
}

class FakeUserRepository extends Fake implements UserRepository {
  @override
  Future<UserData?> getUserData() async => null;
}

void main() {
  testWidgets('SplashScreen smoke test — renders loader on first boot', (tester) async {
    final testRouter = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.welcome,
          builder: (context, state) => const Scaffold(body: Text('Welcome')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(FakeDatabase()),
          userRepositoryProvider.overrideWithValue(FakeUserRepository()),
        ],
        child: MaterialApp.router(routerConfig: testRouter),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
