import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/shared/widgets/media_card.dart';
import 'package:movie_test/shared/widgets/media_card_skeleton.dart';
import 'package:movie_test/shared/widgets/media_carousel.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<SearchCubit>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies & series...',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.isLoading) return const SearchResultsSkeleton();
          if (state.movies.isEmpty && state.series.isEmpty) {
            return const Center(child: Text('No results found'));
          }
          return ListView(
            children: [
              if (state.movies.isNotEmpty)
                MediaCarousel<Movie>(
                  title: 'Movies',
                  items: state.movies,
                  hasMore: state.hasMoreMovies,
                  onLoadMore: () =>
                      context.read<SearchCubit>().loadMoreMovies(),
                  itemBuilder: (movie) {
                    final tag = 'search_movie_${movie.id}';
                    return MediaCard(
                      id: movie.id,
                      title: movie.title,
                      posterPath: movie.posterPath,
                      voteAverage: movie.voteAverage,
                      heroTag: tag,
                      onTap: () =>
                          context.push('/movie/${movie.id}', extra: tag),
                    );
                  },
                ),
              if (state.series.isNotEmpty)
                MediaCarousel<Series>(
                  title: 'Series',
                  items: state.series,
                  hasMore: state.hasMoreSeries,
                  onLoadMore: () =>
                      context.read<SearchCubit>().loadMoreSeries(),
                  itemBuilder: (series) {
                    final tag = 'search_series_${series.id}';
                    return MediaCard(
                      id: series.id,
                      title: series.name,
                      posterPath: series.posterPath,
                      voteAverage: series.voteAverage,
                      heroTag: tag,
                      onTap: () =>
                          context.push('/series/${series.id}', extra: tag),
                    );
                  },
                ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
