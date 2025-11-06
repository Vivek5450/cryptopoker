class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, this.prefix);

  @override
  String toString() => "$prefix$message";
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message ?? "Error", "FetchData: ");
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message ?? "Invalid Request", "BadRequest: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message ?? "Unauthorised", "Unauthorised: ");
}