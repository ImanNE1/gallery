// lib/screens/dashboard_screen.dart

import 'dart:io';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/image_storage_service.dart';
import '../models/image_data.dart'; // <-- IMPORT MODEL BARU
import '../widgets/image_tile.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ImageStorageService _storageService = ImageStorageService();
  List<ImageData> _imageDataList = []; // <-- Gunakan List<ImageData>
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    final loadedData = await _storageService.loadSavedImages();
    if (!mounted) return;
    setState(() {
      _imageDataList = loadedData;
      _isLoading = false;
    });
  }

  Future<void> _pickAndSaveImage() async {
    // Pengguna bisa diminta memasukkan deskripsi awal di sini,
    // atau kita berikan deskripsi default kosong.
    final ImageData? newImageData =
        await _storageService.pickAndSaveImage(initialDescription: '');
    if (newImageData != null) {
      await _loadImages(); // Muat ulang semua data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil disimpan!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Tidak ada gambar yang dipilih atau gagal menyimpan.')),
        );
      }
    }
  }

  Future<void> _deleteImage(String filePath) async {
    // Terima filePath
    bool confirmDelete = await showDialog(
            context: context,
            builder: (BuildContext context) {
              /* ... AlertDialog code ... */
              return AlertDialog(
                title: const Text('Konfirmasi Hapus'),
                content: const Text(
                    'Anda yakin ingin menghapus gambar ini dan keterangannya?'),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: <Widget>[
                  TextButton(
                    child: Text('Batal',
                        style: TextStyle(
                            color: AppColors.bodyText.withOpacity(0.8))),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    child: const Text('Hapus'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            }) ??
        false;

    if (confirmDelete) {
      await _storageService.deleteImage(filePath);
      await _loadImages(); // Muat ulang
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil dihapus!')),
        );
      }
    }
  }

  void _viewImageFullScreen(String filePath) {
    // Terima filePath
    String title = filePath.split('/').last;
    if (title.length > 25) {
      title = '${title.substring(0, 22)}...';
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: AppColors.primaryBackground.withOpacity(0.97),
          appBar: CustomAppBar(
            title: 'QR Code', /* ... CustomAppBar code ... */
          ),
          body: Center(
            child: Hero(
              tag: filePath, // Gunakan filePath untuk tag Hero
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 5.0,
                child: Image.file(
                    File(filePath)), // Buat File object dari filePath
              ),
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _editDescription(ImageData imageData) async {
    final TextEditingController controller =
        TextEditingController(text: imageData.description);
    final newDescription = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Keterangan Gambar'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: null, // Memungkinkan banyak baris
            decoration:
                const InputDecoration(hintText: 'Masukkan keterangan...'),
            onSubmitted: (value) {
              // Submit saat menekan enter di keyboard
              Navigator.of(context).pop(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );

    if (newDescription != null && newDescription != imageData.description) {
      bool success = await _storageService.updateImageDescription(
          imageData.filePath, newDescription);
      if (success) {
        await _loadImages(); // Muat ulang untuk menampilkan perubahan
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Keterangan berhasil diperbarui!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memperbarui keterangan.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'QR Code',
        actions: [/* ... actions ... */],
      ),
      body: _isLoading
          ? Center(/* ... SpinKit ... */)
          : _imageDataList.isEmpty
              ? Center(/* ... Empty state ... */)
              : RefreshIndicator(
                  onRefresh: _loadImages,
                  backgroundColor: Theme.of(context).cardColor,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: _imageDataList.length,
                      itemBuilder: (context, index) {
                        final imageDataItem = _imageDataList[index];
                        return ImageTile(
                          imageData: imageDataItem,
                          index: index,
                          onTapImage: () =>
                              _viewImageFullScreen(imageDataItem.filePath),
                          onLongPressImage: () =>
                              _deleteImage(imageDataItem.filePath),
                          onTapDescription:
                              _editDescription, // <-- Handler untuk edit
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickAndSaveImage,
        label: const Text('Tambah Baru'),
        icon: const Icon(Icons.qr_code_scanner),
      ).animate().slideX(/* ... animasi FAB ... */),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
