class ResultStatus<T> {
  bool success() => this.errorMessage == null;
  String? errorMessage;
  T? data;

  ResultStatus({this.errorMessage, this.data});

  ResultStatus.success(this.data);

  ResultStatus.failure(this.errorMessage);

  @override
  String toString() {
    return 'ResultStatus{data: $data, errorMessage: $errorMessage}';
  }
}
