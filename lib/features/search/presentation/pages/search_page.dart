import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/shared/widgets/media_card.dart';
import 'package:movie_test/shared/widgets/media_card_skeleton.dart';
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
          if (state.isLoading) {
            return const SearchResultsSkeleton();
          }
          if (state.movies.isEmpty && state.series.isEmpty) {
            return const Center(child: Text('No results found'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.movies.isNotEmpty) ...[
                Text('Movies', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.movies.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, index) {
                      final movie = state.movies[index];
                      final tag = 'search_movie_${movie.id}';
                      return SizedBox(
                        width: 120,
                        child: MediaCard(
                          id: movie.id,
                          title: movie.title,
                          posterPath: movie.posterPath,
                          voteAverage: movie.voteAverage,
                          heroTag: tag,
                          onTap: () => context.push('/movie/${movie.id}', extra: tag),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (state.series.isNotEmpty) ...[
                Text('Series', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.series.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, index) {
                      final series = state.series[index];
                      final tag = 'search_series_${series.id}';
                      return SizedBox(
                        width: 120,
                        child: MediaCard(
                          id: series.id,
                          title: series.name,
                          posterPath: series.posterPath,
                          voteAverage: series.voteAverage,
                          heroTag: tag,
                          onTap: () => context.push('/series/${series.id}', extra: tag),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
