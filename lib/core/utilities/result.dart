import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// Standard return type for repository methods: either a [Failure] or a
/// success value of type [T]. Prefer pattern matching (`result.match(...)`
/// or `switch (result)`) over manual null checks at call sites.
typedef Result<T> = Either<Failure, T>;
