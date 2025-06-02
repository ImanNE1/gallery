// lib/services/image_storage_service.dart (Dengan Sorting Dinonaktifkan untuk Tes ANR)

import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/image_data.dart'; // Pastikan path model Anda benar

class ImageStorageService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = Uuid();
  static const String _imageDataListKey = 'image_data_list';

  Future<ImageData?> pickAndSaveImage({String initialDescription = ''}) async {
    // debugPrint("---> [SERVICE_SAVE] Attempting to pick image..."); // Aktifkan jika perlu
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // debugPrint("---> [SERVICE_SAVE] Image picked: ${pickedFile.path}");
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = '${_uuid.v4()}.jpg';
        final String filePath = '${appDir.path}/$fileName';

        // debugPrint("---> [SERVICE_SAVE] Copying to: $filePath");
        await File(pickedFile.path).copy(filePath);
        // debugPrint("===> [SERVICE_SAVE] SUCCESSFULLY COPIED FILE TO DISK: $filePath");

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String encodedCurrentList =
            prefs.getString(_imageDataListKey) ?? '';
        List<ImageData> images = ImageDataUtils.decodeList(encodedCurrentList);

        final newImageData =
            ImageData(filePath: filePath, description: initialDescription);
        images.add(newImageData);

        await prefs.setString(
            _imageDataListKey, ImageDataUtils.encodeList(images));
        // debugPrint("===> [SERVICE_SAVE] ImageData saved to SharedPreferences. Path: ${newImageData.filePath}, Desc: ${newImageData.description}");
        // debugPrint("===> [SERVICE_SAVE] ALL ImageData IN PREFS AFTER SAVE: ${ImageDataUtils.encodeList(images)}");

        return newImageData;
      } else {
        // debugPrint("---> [SERVICE_SAVE] Image picking cancelled.");
        return null;
      }
    } catch (e) {
      debugPrint("!!!> [SERVICE_SAVE] ERROR during pick/save: $e");
      return null;
    }
  }

  Future<List<ImageData>> loadSavedImages() async {
    debugPrint(
        "---> [SERVICE_LOAD] Loading saved ImageData list (SORTING DISABLED FOR TEST)...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedImages = prefs.getString(_imageDataListKey) ?? '';

    if (encodedImages.isEmpty) {
      debugPrint(
          "---> [SERVICE_LOAD] No ImageData found in SharedPreferences.");
      return [];
    }

    List<ImageData> allImageData = ImageDataUtils.decodeList(encodedImages);
    // debugPrint("---> [SERVICE_LOAD] Decoded ImageData from SharedPreferences: count ${allImageData.length}");

    List<ImageData> validImageData = [];
    bool listModifiedDueToMissingFiles = false;

    for (ImageData data in allImageData) {
      final file = File(data.filePath);
      bool exists = await file.exists();
      // debugPrint("---> [SERVICE_LOAD] Checking file: ${data.filePath} - Exists: $exists");
      if (exists) {
        validImageData.add(data);
      } else {
        debugPrint(
            "!!!> [SERVICE_LOAD] File NOT FOUND for ImageData: ${data.filePath}. Removing from list.");
        listModifiedDueToMissingFiles = true;
      }
    }

    if (listModifiedDueToMissingFiles) {
      // debugPrint("---> [SERVICE_LOAD] Some files were missing. Updating SharedPreferences with valid ImageData only.");
      await prefs.setString(
          _imageDataListKey, ImageDataUtils.encodeList(validImageData));
    }

    // ---- BLOK PENGURUTAN DINONAKTIFKAN UNTUK TES ANR ----
    /*
    if (validImageData.isNotEmpty) {
      try {
        debugPrint("---> [SERVICE_LOAD] Attempting to sort ${validImageData.length} ImageData items by file modification date (CURRENTLY DISABLED)...");
        
        // Map<String, ImageData> pathToImageDataMap = { for (var data in validImageData) data.filePath : data };
        // List<File> filesToSort = validImageData.map((data) => File(data.filePath)).toList();

        // filesToSort.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync())); 
            
        // validImageData = filesToSort.map((file) => pathToImageDataMap[file.path]!).toList();

        // debugPrint("===> [SERVICE_LOAD] Images would have been sorted successfully by file modification date (desc).");

      } catch (e) {
        debugPrint("!!!> [SERVICE_LOAD] ERROR during sorting (which is disabled): $e. Returning unsorted list.");
      }
    }
    */
    debugPrint("===> [SERVICE_LOAD] Image sorting SKIPPED for ANR test.");
    // ----------------------------------------------------

    debugPrint(
        "===> [SERVICE_LOAD] Returning ${validImageData.length} VALID ImageData items (unsorted).");
    return validImageData;
  }

  Future<void> deleteImage(String filePathToDelete) async {
    // ... (kode deleteImage tetap sama seperti versi terakhir yang sukses, tanpa print intensif) ...
    debugPrint(
        "---> [SERVICE_DELETE] Attempting to delete image data for path: $filePathToDelete");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedCurrentList =
          prefs.getString(_imageDataListKey) ?? '';
      List<ImageData> images = ImageDataUtils.decodeList(encodedCurrentList);

      int initialLength = images.length;
      images.removeWhere((imgData) => imgData.filePath == filePathToDelete);

      if (images.length < initialLength) {
        final file = File(filePathToDelete);
        if (await file.exists()) {
          await file.delete();
          // debugPrint("===> [SERVICE_DELETE] Physical file deleted: $filePathToDelete");
        }
        await prefs.setString(
            _imageDataListKey, ImageDataUtils.encodeList(images));
        // debugPrint("===> [SERVICE_DELETE] ImageData for $filePathToDelete removed from SharedPreferences.");
      } else {
        // debugPrint("!!!> [SERVICE_DELETE] ImageData with path $filePathToDelete not found in SharedPreferences.");
      }
    } catch (e) {
      debugPrint("!!!> [SERVICE_DELETE] ERROR while deleting ImageData: $e");
    }
  }

  Future<bool> updateImageDescription(
      String filePath, String newDescription) async {
    // ... (kode updateImageDescription tetap sama seperti versi terakhir yang sukses, tanpa print intensif) ...
    debugPrint(
        "---> [SERVICE_UPDATE_DESC] Attempting to update description for: $filePath");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedCurrentList =
          prefs.getString(_imageDataListKey) ?? '';
      List<ImageData> images = ImageDataUtils.decodeList(encodedCurrentList);

      int imageIndex = images.indexWhere((img) => img.filePath == filePath);

      if (imageIndex != -1) {
        images[imageIndex].description = newDescription;
        await prefs.setString(
            _imageDataListKey, ImageDataUtils.encodeList(images));
        // debugPrint("===> [SERVICE_UPDATE_DESC] Description updated for $filePath to: $newDescription");
        return true;
      } else {
        // debugPrint("!!!> [SERVICE_UPDATE_DESC] ImageData with path $filePath not found for update.");
        return false;
      }
    } catch (e) {
      debugPrint("!!!> [SERVICE_UPDATE_DESC] ERROR updating description: $e");
      return false;
    }
  }
}

// // lib/services/image_storage_service.dart

// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import '../models/image_data.dart'; // <-- IMPORT MODEL BARU KITA

// class ImageStorageService {
//   final ImagePicker _picker = ImagePicker();
//   final Uuid _uuid = Uuid();
//   static const String _imageDataListKey =
//       'image_data_list'; // Key baru untuk SharedPreferences

//   Future<ImageData?> pickAndSaveImage({String initialDescription = ''}) async {
//     debugPrint("---> [SERVICE_SAVE] Attempting to pick image...");
//     try {
//       final XFile? pickedFile =
//           await _picker.pickImage(source: ImageSource.gallery);

//       if (pickedFile != null) {
//         debugPrint("---> [SERVICE_SAVE] Image picked: ${pickedFile.path}");
//         final Directory appDir = await getApplicationDocumentsDirectory();
//         final String fileName = '${_uuid.v4()}.jpg';
//         final String filePath = '${appDir.path}/$fileName';

//         debugPrint("---> [SERVICE_SAVE] Copying to: $filePath");
//         await File(pickedFile.path).copy(filePath); // Simpan file fisiknya dulu
//         debugPrint(
//             "===> [SERVICE_SAVE] SUCCESSFULLY COPIED FILE TO DISK: $filePath");

//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         final String encodedCurrentList =
//             prefs.getString(_imageDataListKey) ?? '';
//         List<ImageData> images = ImageDataUtils.decodeList(encodedCurrentList);

//         final newImageData =
//             ImageData(filePath: filePath, description: initialDescription);
//         images.add(newImageData);

//         await prefs.setString(
//             _imageDataListKey, ImageDataUtils.encodeList(images));
//         debugPrint(
//             "===> [SERVICE_SAVE] ImageData saved to SharedPreferences. Path: ${newImageData.filePath}, Desc: ${newImageData.description}");
//         debugPrint(
//             "===> [SERVICE_SAVE] ALL ImageData IN PREFS AFTER SAVE: ${ImageDataUtils.encodeList(images)}");

//         return newImageData;
//       } else {
//         debugPrint("---> [SERVICE_SAVE] Image picking cancelled.");
//         return null;
//       }
//     } catch (e) {
//       debugPrint("!!!> [SERVICE_SAVE] ERROR during pick/save: $e");
//       return null;
//     }
//   }

//   Future<List<ImageData>> loadSavedImages() async {
//     debugPrint("---> [SERVICE_LOAD] Loading saved ImageData list...");
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String encodedImages = prefs.getString(_imageDataListKey) ?? '';

//     if (encodedImages.isEmpty) {
//       debugPrint(
//           "---> [SERVICE_LOAD] No ImageData found in SharedPreferences.");
//       return [];
//     }

//     List<ImageData> allImageData = ImageDataUtils.decodeList(encodedImages);
//     debugPrint(
//         "---> [SERVICE_LOAD] Decoded ImageData from SharedPreferences: count ${allImageData.length}");

//     List<ImageData> validImageData = [];
//     bool listModifiedDueToMissingFiles = false;

//     for (ImageData data in allImageData) {
//       final file = File(data.filePath);
//       bool exists = await file.exists();
//       // debugPrint("---> [SERVICE_LOAD] Checking file: ${data.filePath} - Exists: $exists");
//       if (exists) {
//         validImageData.add(data);
//       } else {
//         debugPrint(
//             "!!!> [SERVICE_LOAD] File NOT FOUND for ImageData: ${data.filePath}. Removing from list.");
//         listModifiedDueToMissingFiles = true;
//       }
//     }

//     if (listModifiedDueToMissingFiles) {
//       debugPrint(
//           "---> [SERVICE_LOAD] Some files were missing. Updating SharedPreferences with valid ImageData only.");
//       await prefs.setString(
//           _imageDataListKey, ImageDataUtils.encodeList(validImageData));
//     }

//     // Pengurutan gambar berdasarkan path (nama file yang mengandung UUID, akan mirip urutan waktu)
//     // Atau bisa diurutkan berdasarkan kriteria lain jika ada timestamp di ImageData
//     if (validImageData.isNotEmpty) {
//       try {
//         // Mengurutkan berdasarkan nama file path, yang mana UUID di awal akan memberi efek kronologis terbalik jika UUID time-based
//         // Untuk sorting berdasarkan tanggal modifikasi file sebenarnya, kita perlu `File` object
//         // Mari kita urutkan berdasarkan path string saja untuk kesederhanaan saat ini,
//         // atau bisa juga berdasarkan tanggal modifikasi file jika diinginkan (perlu load File object dulu)
//         validImageData.sort((a, b) => b.filePath
//             .compareTo(a.filePath)); // Newest UUIDs (later strings) first
//         debugPrint(
//             "===> [SERVICE_LOAD] ImageData list sorted by filePath (desc).");
//       } catch (e) {
//         debugPrint(
//             "!!!> [SERVICE_LOAD] ERROR during sorting ImageData: $e. Returning unsorted list.");
//       }
//     }

//     debugPrint(
//         "===> [SERVICE_LOAD] LOADED ${validImageData.length} VALID ImageData items.");
//     return validImageData;
//   }

//   Future<void> deleteImage(String filePathToDelete) async {
//     debugPrint(
//         "---> [SERVICE_DELETE] Attempting to delete image data for path: $filePathToDelete");
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String encodedCurrentList =
//           prefs.getString(_imageDataListKey) ?? '';
//       List<ImageData> images = ImageDataUtils.decodeList(encodedCurrentList);

//       int initialLength = images.length;
//       images.removeWhere((imgData) => imgData.filePath == filePathToDelete);

//       if (images.length < initialLength) {
//         // Jika ada item yang dihapus dari list
//         final file = File(filePathToDelete);
//         if (await file.exists()) {
//           await file.delete();
//           debugPrint(
//               "===> [SERVICE_DELETE] Physical file deleted: $filePathToDelete");
//         }
//         await prefs.setString(
//             _imageDataListKey, ImageDataUtils.encodeList(images));
//         debugPrint(
//             "===> [SERVICE_DELETE] ImageData for $filePathToDelete removed from SharedPreferences.");
//       } else {
//         debugPrint(
//             "!!!> [SERVICE_DELETE] ImageData with path $filePathToDelete not found in SharedPreferences.");
//       }
//     } catch (e) {
//       debugPrint("!!!> [SERVICE_DELETE] ERROR while deleting ImageData: $e");
//     }
//   }

//   Future<bool> updateImageDescription(
//       String filePath, String newDescription) async {
//     debugPrint(
//         "---> [SERVICE_UPDATE_DESC] Attempting to update description for: $filePath");
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String encodedCurrentList =
//           prefs.getString(_imageDataListKey) ?? '';
//       List<ImageData> images = ImageDataUtils.decodeList(encodedCurrentList);

//       int imageIndex = images.indexWhere((img) => img.filePath == filePath);

//       if (imageIndex != -1) {
//         images[imageIndex].description = newDescription;
//         await prefs.setString(
//             _imageDataListKey, ImageDataUtils.encodeList(images));
//         debugPrint(
//             "===> [SERVICE_UPDATE_DESC] Description updated for $filePath to: $newDescription");
//         return true;
//       } else {
//         debugPrint(
//             "!!!> [SERVICE_UPDATE_DESC] ImageData with path $filePath not found for update.");
//         return false;
//       }
//     } catch (e) {
//       debugPrint("!!!> [SERVICE_UPDATE_DESC] ERROR updating description: $e");
//       return false;
//     }
//   }
// }
