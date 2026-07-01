abstract final class AppConfig {
  static const tmdbAccessToken = String.fromEnvironment('TMDB_ACCESS_TOKEN');
  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
}
