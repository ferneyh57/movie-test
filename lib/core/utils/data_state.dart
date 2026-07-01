import 'package:movie_test/core/error/failures.dart';

sealed class DataState<T> {
  const DataState();
}

final class DataSuccess<T> extends DataState<T> {
  final T data;
  const DataSuccess(this.data);
}

final class DataFailure<T> extends DataState<T> {
  final Failure failure;
  const DataFailure(this.failure);
}
