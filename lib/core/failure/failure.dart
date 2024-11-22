class AppFailure {
  AppFailure([this.message = 'Sorry, something went wrong.']);
  final String message;

  @override
  String toString() => message;
}
