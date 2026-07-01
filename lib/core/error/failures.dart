sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);
}
