// lib/widgets/image_tile.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/image_data.dart'; // <-- IMPORT MODEL BARU
import '../utils/app_colors.dart';

class ImageTile extends StatelessWidget {
  final ImageData imageData; // <-- TERIMA ImageData
  final VoidCallback? onTapImage; // Callback untuk tap pada gambar (fullscreen)
  final VoidCallback?
      onLongPressImage; // Callback untuk long press pada gambar (delete)
  final Function(ImageData)?
      onTapDescription; // Callback untuk tap pada deskripsi (edit)
  final int index;

  const ImageTile({
    super.key,
    required this.imageData, // <-- imageData
    this.onTapImage,
    this.onLongPressImage,
    this.onTapDescription,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      // Card membungkus semuanya
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4.0,
      // Margin dan shape Card akan diambil dari tema
      child: Column(
        // Gunakan Column untuk gambar di atas, deskripsi di bawah
        mainAxisSize: MainAxisSize
            .min, // Agar Column mengambil ukuran minimal yang diperlukan
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Agar anak-anaknya mengisi lebar
        children: [
          GestureDetector(
            // GestureDetector untuk gambar
            onTap: onTapImage,
            onLongPress: onLongPressImage,
            child: Hero(
              tag: imageData.filePath, // Gunakan filePath untuk Hero tag
              child: Stack(
                // Stack untuk tombol delete di atas gambar jika diperlukan nanti, atau overlay
                // Untuk saat ini, kita fokus pada gambar dan deskripsi
                children: [
                  Image.file(
                    File(imageData
                        .filePath), // Gunakan File dari imageData.filePath
                    fit: BoxFit.cover,
                    // Tinggi gambar bisa diatur di sini atau membiarkannya mengikuti aspek rasio
                    // dalam batasan yang diberikan oleh MasonryGridView
                    // Misalnya, Anda bisa membungkus Image.file dengan AspectRatio
                    // Jika tidak, tinggi akan ditentukan oleh bagaimana MasonryGridView menangani itemnya
                    // Untuk MasonryGridView, biasanya lebar ditentukan kolom, tinggi mengikuti konten
                    height:
                        180, // Berikan tinggi contoh, atau biarkan MasonryGridView yang atur
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      if (frame == null) {
                        return Container(
                          height: 180, // Sesuaikan dengan tinggi gambar di atas
                          color: AppColors.cardBackground.withOpacity(0.1),
                          alignment: Alignment.center,
                          // child: const Text("LOADING...", style: TextStyle(color: Colors.white70, fontSize: 10)),
                        );
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180, // Sesuaikan dengan tinggi gambar di atas
                        color: AppColors.accentColor.withOpacity(0.2),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.broken_image_outlined,
                            color: Colors.white70, size: 30),
                      );
                    },
                  ),
                  if (onLongPressImage != null) // Tombol delete di atas gambar
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            AppColors.cardBackground.withOpacity(0.7),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.accentColor),
                          onPressed: onLongPressImage,
                          tooltip: 'Hapus Gambar',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Bagian untuk deskripsi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              // InkWell agar area deskripsi bisa diklik
              onTap: () {
                if (onTapDescription != null) {
                  onTapDescription!(imageData);
                }
              },
              child: Row(
                // Row untuk teks deskripsi dan ikon edit
                children: [
                  Expanded(
                    child: Text(
                      imageData.description.isEmpty
                          ? (onTapDescription != null
                              ? 'Tambah keterangan...'
                              : '-') // Teks jika kosong
                          : imageData.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: imageData.description.isEmpty
                            ? AppColors.bodyText.withOpacity(0.6)
                            : AppColors.bodyText,
                        fontStyle: imageData.description.isEmpty &&
                                onTapDescription != null
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onTapDescription !=
                      null) // Tampilkan ikon edit jika ada handler
                    const SizedBox(width: 4),
                  if (onTapDescription != null)
                    Icon(Icons.edit_outlined,
                        size: 16, color: AppColors.bodyText.withOpacity(0.7)),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate() // Terapkan animasi pada Card
        .fadeIn(duration: 500.ms, delay: (100 * index).ms)
        .slideY(
            begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOutCirc);
  }
}
