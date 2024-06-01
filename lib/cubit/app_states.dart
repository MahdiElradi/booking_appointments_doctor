enum States { idle, loading, success, error }

class BlocAppStatus<T> {
  final States status;
  final T? data;
  final dynamic error;
  BlocAppStatus({
    required this.status,
    this.data,
    this.error,
  });
}
