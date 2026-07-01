import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';
import 'package:movie_test/shared/widgets/media_card.dart';
import 'package:movie_test/shared/widgets/media_grid.dart';
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

class SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: false,
          decoration: const InputDecoration(
            hintText: 'Search movies & series...',
            border: InputBorder.none,
          ),
          onChanged: (query) => context.read<SearchCubit>().search(query),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Movies'), Tab(text: 'Series')],
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.query.isEmpty) {
            return const Center(child: Text('Search for movies or series'));
          }
          return TabBarView(
            controller: _tabController,
            children: [
              MediaGrid<Movie>(
                isLoading: state.isLoading,
                errorMessage: state.errorMessage,
                items: state.movies,
                itemBuilder: (movie) => MediaCard(
                  id: movie.id,
                  title: movie.title,
                  posterPath: movie.posterPath,
                  voteAverage: movie.voteAverage,
                  onTap: () => context.push('/movie/${movie.id}'),
                ),
              ),
              MediaGrid<Series>(
                isLoading: state.isLoading,
                errorMessage: state.errorMessage,
                items: state.series,
                itemBuilder: (series) => MediaCard(
                  id: series.id,
                  title: series.name,
                  posterPath: series.posterPath,
                  voteAverage: series.voteAverage,
                  onTap: () => context.push('/series/${series.id}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
