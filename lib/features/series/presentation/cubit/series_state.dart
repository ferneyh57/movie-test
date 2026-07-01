import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

part 'series_state.freezed.dart';

@freezed
abstract class SeriesState with _$SeriesState {
  const factory SeriesState({
    @Default([]) List<Series> series,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SeriesState;
}
