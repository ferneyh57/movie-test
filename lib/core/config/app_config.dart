abstract final class AppConfig {
  static const tmdbAccessToken = String.fromEnvironment('TMDB_ACCESS_TOKEN');
  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static void validate() {
    assert(
      tmdbAccessToken.isNotEmpty,
      'TMDB_ACCESS_TOKEN missing. Run with --dart-define=TMDB_ACCESS_TOKEN=your_token',
    );
  }
}
