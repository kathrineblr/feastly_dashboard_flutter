import 'dart:typed_data';

import 'package:http/http.dart' as http;

class FetchFromUrl {

  Future<Uint8List?> fetchImageBytesFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        // print('Failed to load image from URL: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching image: $e');
      return null;
    }
  }
}