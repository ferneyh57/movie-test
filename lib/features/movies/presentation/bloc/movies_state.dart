import 'package:movie_test/features/movies/domain/entities/movie.dart';

class MoviesState {
  final List<Movie> movies;
  final bool isLoading;
  final String? errorMessage;

  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MoviesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? errorMessage,
  }) =>
      MoviesState(
        movies: movies ?? this.movies,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}
