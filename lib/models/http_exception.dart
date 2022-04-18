class HttpException implements Exception {
  HttpException({required this.message});
  final String message;

  @override
  String toString() {
    return message;

    // return super.toString();
  }
}
