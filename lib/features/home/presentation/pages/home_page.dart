import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_test/core/config/app_config.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_test/features/home/presentation/cubit/home_state.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/shared/widgets/media_card.dart';
import 'package:movie_test/shared/widgets/media_carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final featured = state.popularMovies.isNotEmpty
            ? state.popularMovies.first
            : null;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 420,
                pinned: true,
                stretch: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => context.push('/search'),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: featured != null
                      ? FeaturedBanner(movie: featured)
                      : const SizedBox.shrink(),
                ),
              ),
              SliverList.list(
                children: [
                  MediaCarousel<Movie>(
                    title: 'Popular Movies',
                    items: state.popularMovies,
                    itemBuilder: (movie) => MediaCard(
                      id: movie.id,
                      title: movie.title,
                      posterPath: movie.posterPath,
                      voteAverage: movie.voteAverage,
                      onTap: () => context.push('/movie/${movie.id}'),
                    ),
                  ),
                  MediaCarousel<Movie>(
                    title: 'Top Rated Movies',
                    items: state.topRatedMovies,
                    itemBuilder: (movie) => MediaCard(
                      id: movie.id,
                      title: movie.title,
                      posterPath: movie.posterPath,
                      voteAverage: movie.voteAverage,
                      onTap: () => context.push('/movie/${movie.id}'),
                    ),
                  ),
                  MediaCarousel<Series>(
                    title: 'Popular Series',
                    items: state.popularSeries,
                    itemBuilder: (series) => MediaCard(
                      id: series.id,
                      title: series.name,
                      posterPath: series.posterPath,
                      voteAverage: series.voteAverage,
                      onTap: () => context.push('/series/${series.id}'),
                    ),
                  ),
                  MediaCarousel<Series>(
                    title: 'Top Rated Series',
                    items: state.topRatedSeries,
                    itemBuilder: (series) => MediaCard(
                      id: series.id,
                      title: series.name,
                      posterPath: series.posterPath,
                      voteAverage: series.voteAverage,
                      onTap: () => context.push('/series/${series.id}'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class FeaturedBanner extends StatelessWidget {
  final Movie movie;

  const FeaturedBanner({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (movie.backdropPath != null)
          Image.network(
            '${AppConfig.tmdbImageBaseUrl}${movie.backdropPath}',
            fit: BoxFit.cover,
          )
        else
          Container(color: Colors.grey.shade900),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (movie.releaseDate != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      movie.releaseDate!.substring(0, 4),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
