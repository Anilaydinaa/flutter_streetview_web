enum StreetViewErrorType {
  apiLoadFailed,
  initializationFailed,
  webViewError,
  assetLoadError,
  locationUnavailable,
  invalidCoordinates,
  invalidApiKey,
}

class StreetViewException implements Exception {
  final StreetViewErrorType errorType;
  final String message;
  final dynamic underlyingError;
  final StackTrace? stackTrace;

  StreetViewException(
    this.errorType,
    this.message, {
    this.underlyingError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'StreetViewException: $message (Type: $errorType)'
        '${underlyingError != null ? '\nUnderlying error: $underlyingError' : ''}'
        '${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}';
  }
}