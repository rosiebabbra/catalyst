String formatPhoneNumber(String exitCode, String phoneNumber, bool withSpaces) {
  // Remove all non-numeric characters from the phone number
  String digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

  // Extract the area code, prefix, and line number
  String areaCode = digitsOnly.substring(0, 3);
  String prefix = digitsOnly.substring(3, 6);
  String lineNumber = digitsOnly.substring(6);

  // Format the phone number with spaces
  if (withSpaces) {
    return '$exitCode $areaCode $prefix $lineNumber';
  } else {
    return '$exitCode$areaCode$prefix$lineNumber';
  }
}
