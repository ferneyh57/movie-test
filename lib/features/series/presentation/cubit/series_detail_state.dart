import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_test/features/series/domain/entities/series.dart';

part 'series_detail_state.freezed.dart';

@freezed
abstract class SeriesDetailState with _$SeriesDetailState {
  const factory SeriesDetailState({
    Series? series,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SeriesDetailState;
}
