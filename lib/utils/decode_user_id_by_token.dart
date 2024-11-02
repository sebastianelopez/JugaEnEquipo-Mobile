import 'dart:convert';

String decodeUserIdByToken(String token) {
  // Split the token into its three parts
  final parts = token.split('.');
  if (parts.length != 3) {
    throw const FormatException('Invalid token');
  }

  // Decode the second part (payload)
  final payload = parts[1];
  final normalized = base64.normalize(payload);
  final decodedBytes = base64.decode(normalized);
  final decodedString = utf8.decode(decodedBytes);

  // Extract the user ID from the decoded payload
  final payloadMap = json.decode(decodedString);
  final decodedId = payloadMap['id'];

  if (decodedId == null) {
    throw const FormatException('ID not found in token payload');
  }
  return decodedId;
}
