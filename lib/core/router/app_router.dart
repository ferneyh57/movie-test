import 'package:go_router/go_router.dart';
import 'package:movie_test/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:movie_test/features/search/presentation/pages/search_page.dart';
import 'package:movie_test/features/series/presentation/pages/series_detail_page.dart';
import 'package:movie_test/features/home/presentation/pages/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          builder: (context, state) => MovieDetailPage(
            movieId: int.parse(state.pathParameters['id']!),
            heroTag: state.extra as String?,
          ),
        ),
        GoRoute(
          path: 'series/:id',
          builder: (context, state) => SeriesDetailPage(
            seriesId: int.parse(state.pathParameters['id']!),
            heroTag: state.extra as String?,
          ),
        ),
        GoRoute(
          path: 'search',
          builder: (context, state) => const SearchPage(),
        ),
      ],
    ),
  ],
);
