// lib/models/image_data.dart

import 'dart:convert'; // Untuk jsonEncode dan jsonDecode

class ImageData {
  final String filePath; // Akan berfungsi sebagai ID unik untuk gambar ini
  String description;

  ImageData({
    required this.filePath,
    this.description = '', // Deskripsi default adalah string kosong
  });

  // Konversi objek ImageData menjadi Map untuk disimpan sebagai JSON
  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'description': description,
    };
  }

  // Buat objek ImageData dari Map (hasil parsing JSON)
  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      filePath: json['filePath'] as String,
      description:
          json['description'] as String? ?? '', // Handle jika deskripsi null
    );
  }
}

// Fungsi helper untuk ImageStorageService
class ImageDataUtils {
  static String encodeList(List<ImageData> images) {
    return jsonEncode(images.map((image) => image.toJson()).toList());
  }

  static List<ImageData> decodeList(String encodedImages) {
    if (encodedImages.isEmpty) {
      return [];
    }
    final List<dynamic> decodedJson =
        jsonDecode(encodedImages) as List<dynamic>;
    return decodedJson
        .map((jsonItem) => ImageData.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }
}
