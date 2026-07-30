/// Base type for all recoverable, user-facing errors surfaced by repositories.
///
/// Repositories never throw for expected failure paths (bad credentials, no
/// network, validation errors) — they return `Either<Failure, T>` so callers
/// are forced to handle the error case. Unexpected exceptions still propagate.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
