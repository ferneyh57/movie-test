import 'package:flutter/material.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/movies/presentation/pages/movies_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Movie Test',
      home: MoviesPage(),
    );
  }
}
