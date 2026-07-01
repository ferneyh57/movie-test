import 'package:movie_test/features/series/domain/usecases/get_popular_series.dart';
import 'series_cubit.dart';

class PopularSeriesCubit extends SeriesCubit {
  PopularSeriesCubit({required GetPopularSeries getPopularSeries})
      : super(getSeries: getPopularSeries);
}
