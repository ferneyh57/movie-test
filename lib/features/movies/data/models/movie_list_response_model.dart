import 'package:freezed_annotation/freezed_annotation.dart';
import 'movie_model.dart';

part 'movie_list_response_model.freezed.dart';
part 'movie_list_response_model.g.dart';

@freezed
abstract class MovieListResponseModel with _$MovieListResponseModel {
  const factory MovieListResponseModel({
    required List<MovieModel> results,
    required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _MovieListResponseModel;

  factory MovieListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseModelFromJson(json);
}
