import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryException implements Exception {
  final String message;
  final int? statusCode;

  CloudinaryException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'CloudinaryException: $message${statusCode != null ? ' (StatusCode: $statusCode)' : ''}';
  }
}

class CloudinaryService {
  final String cloudName = 'djnfz4ehq'; // Loaded from .env
  final String apiKey = ''; // Loaded from .env
  final String apiSecret = ''; // Loaded from .env

  Future<String> uploadImage(File imageFile) async {
    final String url = 'https://api.cloudinary.com/v1_1/$cloudName/upload';
    final String base64Auth = base64Encode(utf8.encode('$apiKey:$apiSecret'));

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      // request.headers['Authorization'] = 'Basic $base64Auth';
      request.fields['upload_preset'] = 'custom1';
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        throw CloudinaryException(
            'Failed to upload image: $responseBody', response.statusCode);
      }

      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);

      if (jsonResponse['secure_url'] == null) {
        throw CloudinaryException(
            'Invalid response from Cloudinary: secure_url is missing');
      }

      return jsonResponse['secure_url'];
    } catch (e) {
      if (e is CloudinaryException) {
        rethrow; // Re-throw CloudinaryExceptions to be handled by the caller
      } else if (e is SocketException) {
        throw CloudinaryException('Network error: ${e.message}');
      } else {
        throw CloudinaryException(
            'An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> deleteImages(List<String> publicIds) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload');

    final headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = publicIds.map((id) => 'public_ids[]=$id').join('&');

    final response = await http.delete(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete images: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  String extractPublicId(String imageUrl) {
    final regex = RegExp(r'/([^/]+)\.[a-zA-Z]{3,4}'); // Matches "filename.ext"
    final match = regex.firstMatch(imageUrl);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!; // Extracts the public ID
    } else {
      throw Exception('Invalid Cloudinary URL');
    }
  }
}
