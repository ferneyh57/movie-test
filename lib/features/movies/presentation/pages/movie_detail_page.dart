import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/config/app_config.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie_test/features/movies/presentation/bloc/movie_detail_state.dart';
import 'package:movie_test/shared/widgets/media_card_skeleton.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;
  final String? heroTag;

  const MovieDetailPage({super.key, required this.movieId, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieDetailCubit>()..load(movieId),
      child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const DetailPageSkeleton();
          }
          if (state.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(state.errorMessage!)),
            );
          }
          if (state.movie == null) return const SizedBox.shrink();
          return MovieDetailContent(movie: state.movie!, heroTag: heroTag);
        },
      ),
    );
  }
}

class MovieDetailContent extends StatelessWidget {
  final Movie movie;
  final String? heroTag;

  const MovieDetailContent({super.key, required this.movie, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final tag = heroTag ?? 'media_${movie.id}';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie.title),
              background: Hero(
                tag: tag,
                child: movie.backdropPath != null
                    ? Image.network(
                        '${AppConfig.tmdbImageBaseUrl}${movie.backdropPath}',
                        fit: BoxFit.cover,
                      )
                    : Container(color: Colors.grey.shade800),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (movie.voteCount != null) ...[
                      const SizedBox(width: 8),
                      Text('(${movie.voteCount} votes)',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                    const Spacer(),
                    if (movie.releaseDate != null)
                      Text(movie.releaseDate!,
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(movie.overview),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
