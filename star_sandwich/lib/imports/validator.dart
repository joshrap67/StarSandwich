String? validAddress(String? input) {
  String? val;
  if (input?.isEmpty ?? true) {
    val = 'Location cannot be empty';
  }
  return val;
}
