import 'package:flutter/material.dart';
import 'package:movie_test/core/config/app_config.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie Test',
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
