import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:movie_test/shared/widgets/media_card_skeleton.dart';
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
        final cubit = context.read<HomeCubit>();

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
                  background: state.isLoading
                      ? const FeaturedBannerSkeleton()
                      : state.popularMovies.isNotEmpty
                          ? FeaturedBanner(movies: state.popularMovies.take(5).toList())
                          : const SizedBox.shrink(),
                ),
              ),
              SliverList.list(
                children: [
                  MediaCarousel<Movie>(
                    title: 'Popular Movies',
                    items: state.popularMovies,
                    hasMore: state.hasMorePopularMovies,
                    onLoadMore: () => cubit.loadMore(HomeCategory.popularMovies),
                    itemBuilder: (movie) {
                      final tag = 'pop_movie_${movie.id}';
                      return MediaCard(
                        id: movie.id,
                        title: movie.title,
                        posterPath: movie.posterPath,
                        voteAverage: movie.voteAverage,
                        heroTag: tag,
                        onTap: () => context.push('/movie/${movie.id}', extra: tag),
                      );
                    },
                  ),
                  MediaCarousel<Movie>(
                    title: 'Top Rated Movies',
                    items: state.topRatedMovies,
                    hasMore: state.hasMoreTopRatedMovies,
                    onLoadMore: () => cubit.loadMore(HomeCategory.topRatedMovies),
                    itemBuilder: (movie) {
                      final tag = 'top_movie_${movie.id}';
                      return MediaCard(
                        id: movie.id,
                        title: movie.title,
                        posterPath: movie.posterPath,
                        voteAverage: movie.voteAverage,
                        heroTag: tag,
                        onTap: () => context.push('/movie/${movie.id}', extra: tag),
                      );
                    },
                  ),
                  MediaCarousel<Series>(
                    title: 'Popular Series',
                    items: state.popularSeries,
                    hasMore: state.hasMorePopularSeries,
                    onLoadMore: () => cubit.loadMore(HomeCategory.popularSeries),
                    itemBuilder: (series) {
                      final tag = 'pop_series_${series.id}';
                      return MediaCard(
                        id: series.id,
                        title: series.name,
                        posterPath: series.posterPath,
                        voteAverage: series.voteAverage,
                        heroTag: tag,
                        onTap: () => context.push('/series/${series.id}', extra: tag),
                      );
                    },
                  ),
                  MediaCarousel<Series>(
                    title: 'Top Rated Series',
                    items: state.topRatedSeries,
                    hasMore: state.hasMoreTopRatedSeries,
                    onLoadMore: () => cubit.loadMore(HomeCategory.topRatedSeries),
                    itemBuilder: (series) {
                      final tag = 'top_series_${series.id}';
                      return MediaCard(
                        id: series.id,
                        title: series.name,
                        posterPath: series.posterPath,
                        voteAverage: series.voteAverage,
                        heroTag: tag,
                        onTap: () => context.push('/series/${series.id}', extra: tag),
                      );
                    },
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

class FeaturedBanner extends StatefulWidget {
  final List<Movie> movies;

  const FeaturedBanner({super.key, required this.movies});

  @override
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() => _index = (_index + 1) % widget.movies.length);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movies[_index];
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: movie.backdropPath != null
              ? CachedNetworkImage(
                  key: ValueKey(movie.id),
                  imageUrl: '${AppConfig.tmdbImageBaseUrl}${movie.backdropPath}',
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: Colors.grey.shade900),
                  errorWidget: (_, _, _) => Container(color: Colors.grey.shade900),
                )
              : Container(key: ValueKey(movie.id), color: Colors.grey.shade900),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.85),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Column(
                  key: ValueKey(movie.id),
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
              const SizedBox(height: 12),
              Row(
                children: List.generate(
                  widget.movies.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 6),
                    width: i == _index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _index ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
