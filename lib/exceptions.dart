class RefreshTokenException implements Exception {
  final String msg;
  const RefreshTokenException(this.msg);
  String toString() => 'RefreshTokenException: $msg';
}