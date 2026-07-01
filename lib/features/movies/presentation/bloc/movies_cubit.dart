import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_test/core/usecase/usecase.dart';
import 'package:movie_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetPopularMovies getPopularMovies;

  MoviesCubit({required this.getPopularMovies}) : super(const MoviesState());

  Future<void> loadPopularMovies() async {
    emit(state.copyWith(isLoading: true));
    try {
      final movies = await getPopularMovies(const NoParams());
      emit(state.copyWith(movies: movies, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
