import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_test/core/di/injection_container.dart';
import 'package:movie_test/features/movies/domain/entities/movie.dart';
import 'package:movie_test/features/movies/presentation/bloc/movies_cubit.dart';
import 'package:movie_test/features/movies/presentation/bloc/movies_state.dart';
import 'package:movie_test/features/movies/presentation/bloc/popular_movies_cubit.dart';
import 'package:movie_test/features/movies/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:movie_test/shared/widgets/media_card.dart';
import 'package:movie_test/shared/widgets/media_grid.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => MoviesPageState();
}

class MoviesPageState extends State<MoviesPage> {
  late final MoviesCubit _popularCubit;
  late final MoviesCubit _topRatedCubit;

  @override
  void initState() {
    super.initState();
    _popularCubit = sl<PopularMoviesCubit>()..load();
    _topRatedCubit = sl<TopRatedMoviesCubit>()..load();
  }

  @override
  void dispose() {
    _popularCubit.close();
    _topRatedCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Popular'), Tab(text: 'Top Rated')],
          ),
        ),
        body: TabBarView(
          children: [
            MoviesTab(cubit: _popularCubit),
            MoviesTab(cubit: _topRatedCubit),
          ],
        ),
      ),
    );
  }
}

class MoviesTab extends StatelessWidget {
  final MoviesCubit cubit;

  const MoviesTab({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) => MediaGrid<Movie>(
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
      ),
    );
  }
}
