bool isSafeFromSqlInjection(String input) {
  RegExp sqlPattern = RegExp(
    r"(\b(union|select|insert|update|delete|drop|alter)\b)|(--\s|/\*|\*/)",
    caseSensitive: false,
  );
  return !sqlPattern.hasMatch(input);
}
