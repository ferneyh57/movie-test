import 'package:movie_test/features/series/domain/usecases/get_top_rated_series.dart';
import 'series_cubit.dart';

class TopRatedSeriesCubit extends SeriesCubit {
  TopRatedSeriesCubit({required GetTopRatedSeries getTopRatedSeries})
      : super(getSeries: getTopRatedSeries);
}
